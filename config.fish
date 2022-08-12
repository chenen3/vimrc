#if status is-interactive
    # Commands to run in interactive sessions can go here
#end

function proxy
	set --export -g http_proxy "http://127.0.0.1:8080"
	set --export -g https_proxy "http://127.0.0.1:8080"
	echo "set http_proxy to $http_proxy"
end
# use proxy by default
proxy

function unproxy
	set --erase http_proxy
	set --erase https_proxy
end

function checkip
	curl -L https://checkip.amazonaws.com
end

set PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
set --export GOPATH "$(go env GOPATH)"
set --export PATH "$PATH:$GOPATH/bin"

# export something
set --export GOPROXY "https://goproxy.cn,direct"
set --export EDITOR "vim"

alias vi="nvim"
alias vim="nvim"

