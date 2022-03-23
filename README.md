# README

RxR is script that creates a lightweight framework using:
- React frontend  
- Rails API backend 

The purpose is to start building on a bare minimum clean slate. 

## Rails Configuration
#### Modify the Gemfile and config files:
```
1. Gemfile
   Uncomment: gem 'rack-cors', :require => 'rack/cors'

2. config/initializers/cors.rb
   Lines 8-16: Un-comment 
   Line 10: change the code (origins 'example.com') to (origins '*') 
   
3. config/application.rb 
   Add: config.active_record.schema_format = :sql
```
#### Bundle
```
$ bundle install
```

## React Configuration
#### Change directory
```
$ cd app-frontend
```

#### Modify `app-app/package.json`
``` 
# Add under ("private": true,)
"proxy": "http://localhost:3000",

# Replace in scripts ("start": "react-scripts start",)
"start": "set PORT=4000 && react-scripts start",
```

#### React Server
```
$ yarn --cwd app-frontend start
```

## Run Server for both Rails backend and React frontend
```In root directory
$  heroku local -f Procfile.windows
```
