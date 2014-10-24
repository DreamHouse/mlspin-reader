ps -ef | grep ruby | grep -v grep | awk '{print $2}' | xargs kill -9
rails s -d
