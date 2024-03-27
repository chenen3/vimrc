#if status is-interactive
    # Commands to run in interactive sessions can go here
#end

function fish_prompt -d "Write out the prompt"
	set -g __fish_git_prompt_showdirtystate true
    printf '%s%s%s%s> ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (fish_git_prompt)
end

function withproxy
	http_proxy="http://127.0.0.1:8089" https_proxy="http://127.0.0.1:8089" $argv
end

#function proxy
#	set --export -g http_proxy "http://127.0.0.1:8080"
#	set --export -g https_proxy "http://127.0.0.1:8080"
#	set --export -g no_proxy "localhost,127.0.0.1,192.168.1.1"
#	echo "set http_proxy to $http_proxy"
#end
#
#function unproxy
#	set --erase http_proxy
#	set --erase https_proxy
#	set --erase no_proxy
#end

set PATH "/usr/local/go/bin"
set PATH "$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
set --export GOPATH "$(go env GOPATH)"
set PATH "$PATH:$GOPATH/bin"
set --export PATH "/opt/local/bin:/opt/local/sbin:$PATH"

set --export GOPROXY "https://goproxy.cn,direct"
set --export EDITOR "vim"

# make grep human-friendly, will be faster without searching binary files
alias grep "grep --exclude-dir={.git,.vscode} --binary-files=without-match --color=auto -i"

