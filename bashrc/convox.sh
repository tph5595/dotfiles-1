alias cx="convox"

alias cxs="echo formapi > ~/code/docspring/.convox/app \
  && cp ~/.convox/host.staging ~/.convox/host \
  && rm -f ~/.convox/rack \
  && printf 'Switched to Staging host: ' \
  && cat ~/.convox/host"
alias cxp="echo formapi > ~/code/docspring/.convox/app \
  && cp ~/.convox/host.prod ~/.convox/host \
  && cp ~/.convox/rack.prod ~/.convox/rack \
  && printf 'Switched to Prod host: ' \
  && cat ~/.convox/host"
alias cxeu="echo docspring > ~/code/docspring/.convox/app \
  && cp ~/.convox/host.eu ~/.convox/host \
  && rm -f ~/.convox/rack \
  && printf 'Switched to EU host: ' \
  && cat ~/.convox/host"

alias cxr="convox rack"
alias cxe="convox exec"
alias cxru="convox run"
alias cxd="convox deploy --wait"
alias cxl="convox logs"
alias cxrs="convox resources"
alias cxsc="convox scale"
alias cxi="convox instances"
alias cxrl="convox releases"
alias cxb="convox builds"
alias cxps="convox ps"
