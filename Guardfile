guard :rspec, cmd: "bundle exec rspec" do
  # watch /lib/ files
  watch(%r{^lib/(.+).rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end

  # watch /spec/ files
  watch(%r{^spec/(.+).rb$}) do |m|
    "spec/#{m[1]}.rb"
  end
end

guard :shell do
  watch %r{^pair/.*\.rb$} do |m|
    n m[0], 'Changed'
    `bundle exec exe/sendevent "http://c5d68773.ngrok.io" #{m[0]}`
  end
end
