#!/bin/bash
# Copyright 2011 Nathan Broadbent. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: nathan.f77@gmail.com (Nathan Broadbent)
#
# Unit tests for git shell scripts

thisDir="$( cd -P "$( dirname "$0" )" && pwd )"
# Zsh compatibility
if [ -n "${ZSH_VERSION:-}" ]; then SHUNIT_PARENT=$0; setopt shwordsplit; fi

# Load test helpers
source "$thisDir/support/test_helper"

# Load functions to test
source "$thisDir/../git_file_shortcuts.sh"


# Setup and tear down
#-----------------------------------------------------------------------------
oneTimeSetUp() {
  # Test Config
  git_env_char="e"
  gs_max_changes="20"
  ga_auto_remove="yes"

  testRepo=$(mktemp -d)
}

oneTimeTearDown() {
  rm -rf "${testRepo}"
}

setupTestRepo() {
  rm -rf "${testRepo}"
  mkdir -p "$testRepo"
  cd "$testRepo"
  git init > /dev/null
}


#-----------------------------------------------------------------------------
# Unit tests
#-----------------------------------------------------------------------------

test_git_expand_args() {
  local e1="one"; local e2="two"; local e3="three"; local e4="four"; local e5="five"; local e6="six"; local e7="seven"
  local error="Args not expanded correctly"
  assertEquals "$error" "one three seven" "$(git_expand_args 1 3 7)"
  assertEquals "$error" "one two three six" "$(git_expand_args 1..3 6)"
  assertEquals "$error" "seven two three four five one" "$(git_expand_args seven 2..5 1)"
}


test_git_status_with_shortcuts() {
  setupTestRepo

  silentGitCommands

  # Set up some modifications
  touch deleted_file
  git add deleted_file
  git commit -m "Test commit"
  touch new_file
  touch untracked_file
  git add new_file
  echo "changed" > new_file
  rm deleted_file

  verboseGitCommands

  # Test that groups can be filtered by passing a parameter
  git_status1=$(git_status_with_shortcuts 1)
  git_status3=$(git_status_with_shortcuts 3)
  git_status4=$(git_status_with_shortcuts 4)

  # Test for presence of expected groups
  assertIncludes "$git_status1" "Changes to be committed"
  assertIncludes "$git_status3" "Changes not staged for commit"
  assertIncludes "$git_status4" "Untracked files"
  assertNotIncludes "$git_status3" "Changes to be committed"
  assertNotIncludes "$git_status4" "Changes not staged for commit"
  assertNotIncludes "$git_status1" "Untracked files"
  assertNotIncludes "$git_status4" "Changes to be committed"
  assertNotIncludes "$git_status1" "Changes not staged for commit"
  assertNotIncludes "$git_status3" "Untracked files"

  # Run command in shell, load output from temp file into variable
  temp_file=$(mktemp)
  git_status_with_shortcuts > $temp_file
  git_status=$(cat $temp_file | strip_colors)

  assertIncludes "$git_status"  "new file: *\[1\] *new_file"       || return
  assertIncludes "$git_status"   "deleted: *\[2\] *deleted_file"   || return
  assertIncludes "$git_status"  "modified: *\[3\] *new_file"       || return
  assertIncludes "$git_status" "untracked: *\[4\] *untracked_file" || return

  # Test that shortcut env variables are set
  local error="Env variable was not set"
  assertEquals "$error" "new_file" "$e1"       || return
  assertEquals "$error" "deleted_file" "$e2"   || return
  assertEquals "$error" "new_file" "$e3"       || return
  assertEquals "$error" "untracked_file" "$e4" || return
}

test_git_status_produces_relative_paths() {
  setupTestRepo

  mkdir -p dir1/sub1/subsub1
  mkdir -p dir1/sub2
  mkdir -p dir2
  touch dir1/sub1/subsub1/testfile
  touch dir1/sub2/testfile
  touch dir2/testfile
  git add .

  git_status=$(git_status_with_shortcuts | strip_colors)
  assertIncludes "$git_status"  "dir1/sub1/subsub1/testfile" || return

  cd $testRepo/dir1
  git_status=$(git_status_with_shortcuts | strip_colors)
  assertIncludes "$git_status"  " sub1/subsub1/testfile" || return
  assertIncludes "$git_status"  " sub2/testfile" || return
  assertIncludes "$git_status"  "../dir2/testfile" || return

  cd $testRepo/dir1/sub1
  git_status=$(git_status_with_shortcuts | strip_colors)
  assertIncludes "$git_status"  " subsub1/testfile"   || return
  assertIncludes "$git_status"  " ../sub2/testfile"   || return
  assertIncludes "$git_status"  "../../dir2/testfile" || return

  cd $testRepo/dir1/sub1/subsub1
  git_status=$(git_status_with_shortcuts | strip_colors)
  assertIncludes "$git_status"  " testfile" || return
  assertIncludes "$git_status"  " ../../sub2/testfile"   || return
  assertIncludes "$git_status"  "../../../dir2/testfile" || return
}


test_git_status_with_shortcuts_merge_conflicts() {
  setupTestRepo

  silentGitCommands

  # Set up every possible merge conflict
  touch both_modified both_deleted deleted_by_them deleted_by_us
  echo "renamed file needs some content" > renamed_file
  git add both_modified both_deleted renamed_file deleted_by_them deleted_by_us
  git commit -m "First commit"

  git checkout -b conflict_branch
  echo "added by branch" > both_added
  echo "branch line" > both_modified
  echo "deleted by us" > deleted_by_us
  git rm deleted_by_them both_deleted
  git mv renamed_file renamed_file_on_branch
  git add both_added both_modified deleted_by_us
  git commit -m "Branch commit"

  git checkout master
  echo "added by master" > both_added
  echo "master line" > both_modified
  echo "deleted by them" > deleted_by_them
  git rm deleted_by_us both_deleted
  git mv renamed_file renamed_file_on_master
  git add both_added both_modified deleted_by_them
  git commit -m "Master commit"

  git merge conflict_branch

  verboseGitCommands

  # Test output without stripped color codes
  git_status=$(git_status_with_shortcuts | strip_colors)
  assertIncludes "$git_status"      "both added: *\[[0-9]*\] *both_added"             || return
  assertIncludes "$git_status"   "both modified: *\[[0-9]*\] *both_modified"          || return
  assertIncludes "$git_status" "deleted by them: *\[[0-9]*\] *deleted_by_them"        || return
  assertIncludes "$git_status"   "deleted by us: *\[[0-9]*\] *deleted_by_us"          || return
  assertIncludes "$git_status"    "both deleted: *\[[0-9]*\] *renamed_file"           || return
  assertIncludes "$git_status"   "added by them: *\[[0-9]*\] *renamed_file_on_branch" || return
  assertIncludes "$git_status"     "added by us: *\[[0-9]*\] *renamed_file_on_master" || return
}


test_git_status_with_shortcuts_max_changes() {
  setupTestRepo

  local gs_max_changes="5"

  # Add 5 untracked files
  touch a b c d e
  git_status=$(git_status_with_shortcuts | strip_colors)
  for i in $(seq 1 5); do
    assertIncludes "$git_status"  "\[$i\]" || return
  done

  # 6 untracked files is more than $gs_max_changes
  touch f
  git_status=$(git_status_with_shortcuts | strip_colors)
  assertNotIncludes "$git_status"  "\[[0-9]*\]" || return
}


test_git_add_with_shortcuts() {
  setupTestRepo

  touch a b c d e f g h i j
  # Show git status, which sets up env variables
  git_status_with_shortcuts > /dev/null
  git_add_with_shortcuts 2..4 7 8 > /dev/null
  git_status=$(git_status_with_shortcuts 1 | strip_colors)

  for c in b c d g h; do
    assertIncludes "$git_status"  "\[[0-9]*\] $c" || return
  done
}


# load and run shUnit2
runTests
