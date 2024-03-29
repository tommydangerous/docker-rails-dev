# Set the working application directory
app_root          = ENV.fetch "ROOT_DIR", "/opt/app"
working_directory = app_root

# Unicorn PID file location; make sure this directory exists
# pid "#{app_root}/tmp/pids/unicorn.pid"

# Path to logs
stderr_path "#{app_root}/log/unicorn.stderr.log"
stdout_path "#{app_root}/log/unicorn.stdout.log"

# Unicorn socket
listen "/tmp/unicorn.sock", backlog: 64

# Number of processes
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

# Time-out
timeout 30

preload_app true

before_fork do |server, worker|
  Signal.trap "TERM" do
    puts "Unicorn master intercepting TERM and sending myself QUIT instead"
    Process.kill "Quit", Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap "TERM" do
    puts "Unicorn worker intercepting TERM and doing nothing. " \
      "Wait for master to send QUIT"
  end
  
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
