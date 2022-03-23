#!/usr/bin/ruby
app = ARGV[0]

`rvm --default use 3.0.2`

sleep 1.0

puts "Creating Rails API #{app}"
`rails new "#{app}" --api --database=postgresql -T -M -B`

sleep 1.0

puts "Creating Directories for #{app}"
`mkdir "#{app}"/app/controllers/api`
`mkdir "#{app}"/app/controllers/api/v1`

sleep 1.0

puts "Creating React #{app}-frontend"
`create-react-app app-frontend`

sleep 1.0

puts "Moving #{app}-frontend folder"
`mv app-frontend "#{app}"`

puts "Copying files"
`cp /Users/jkai/Development/rxr/README.md /Users/jkai/Development/rxr/EXAMPLE.md /Users/jkai/Development/rxr/Procfile.windows "#{app}"`