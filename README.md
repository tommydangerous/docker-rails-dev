### Artifacts
- Dockerfile
- Procfile
- start-server.sh
- config/unicorn.rb


### Setup
Add gems
```
$ echo 'gem "foreman"' >> Gemfile
$ echo 'gem "unicorn"' >> Gemfile
```

Create /tmp/pids (Only do this step if unicorn.rb file states pid)
```
$ mkdir tmp/pids
```

Docker build and run
```
# Build image
$ docker build -t rails_dev .
# Run bundle install
$ docker run -v $PWD:/opt/app rails_dev bundle install
# Create container and run app
$ docker run -v $PWD:/opt/app -p 3000:8080 rails_dev
```
