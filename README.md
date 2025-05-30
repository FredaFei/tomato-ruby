# Tomato's daily cost web app(Backend)
A lightweight, user-friendly web app for tracking daily expenses and income—simplifying your financial management.

## [Frontend based on Vue3](https://github.com/FredaFei/peach)

## Install
```
bundle install
```

## Connect to the database
```
docker ps -a // Find the last created container
docker restart [container id]
```
If this is the first time starting the database, run the following commands:

```
  docker network create network1

  docker run -d --name db-for-tomato -e POSTGRES_USER=tomato -e POSTGRES_PASSWORD=123456 -e POSTGRES_DB=tomato_dev -e PGDATA=/var/lib/postgresql/data/pgdata -v tomato-data:/var/lib/postgresql/data --network=network1 postgres:14
```

## Create a database

`bin/rails db:create`

## Delete a database

`bin/rails db:drop`

## Run server

`bin/rails s`

## Docker Common Commands
```
# List all containers (running and stopped)
docker ps -a

# Stop a running container by ID
docker kill [container_id]

# Restart a container by ID
docker restart [container_id]

# Remove a stopped container by ID
docker rm [container_id]

# Remove all unused containers
docker container prune
```
## Test

"Running `bundle exec rspec` can be refined with a path to specify which tests to execute, for example, `bundle exec rspec spec/requests/api/v1`.
Both `bin/rspec` and `bundle exec rspec` run RSpec tests, but they function in different environments."

1. `bin/rspec`: This command executes the `rspec` script located in your project's `bin` directory. This script is usually generated automatically when you install RSpec. It runs RSpec within the context of your project's environment. If your project uses Bundler to manage gems and you have specified a version of RSpec in your Gemfile, then `bin/rspec` will use that specific version.

2. `bundle exec rspec`: This command runs RSpec within the context of Bundler. Bundler is a Ruby dependency management tool that ensures your application runs with the exact gem versions specified in your Gemfile. When you run `bundle exec rspec`, Bundler first sets up an environment with these specific dependencies and then executes RSpec within that environment. This means that, regardless of any RSpec versions installed globally on your system, `bundle exec rspec` will always use the version specified in your Gemfile.

## Generate API Documentation

`bin/rake docs:generate`

Note： If this command fails while the project code remains unchanged, try clearing the cache first:
`rm -rf tmp/cache/bootsnap`
Then re-run the documentation generation command.

**Key Differences Between `./spec/acceptance` and `./spec/requests`**
- **Purpose:** Both directories contain tests for controllers.
- **Difference:** `acceptance` Tests successful scenarios only (required for generating documentation). `requests` Tests both success and failure cases.

**Key Differences Between `bundle exec rspec` and `bin/rake docs:generate`**

**`bundle exec rspec`:**
- **Purpose:** Runs automated tests using RSpec, which is Ruby's primary testing framework.
- **Function:** Executes all test cases in your project and reports the results.
- **Outcome:** Ensures that your code functions correctly and is free from regressions.

**`bin/rake docs:generate`:**
- **Purpose:** Generates project documentation, typically for the API.
- **Function:** Executes a custom Rake task (`docs:generate`) defined in your project.
- **Outcome:** Successful execution guarantees that documentation has been generated, but it does not validate test coverage or code correctness.

**Summary**
`bundle exec rspec`: Validates code functionality through tests.  
`bin/rake docs:generate`: Generates documentation based on successful test scenarios.  
**Note**: Passing docs:generate does not imply that all tests passed—only that documentation was created without errors.
