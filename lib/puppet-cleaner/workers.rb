workersglob = File.join(File.dirname(__FILE__), "workers", "*.rb")
Dir[workersglob].each {|worker| require worker }
