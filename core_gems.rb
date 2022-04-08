dir 'core_gems'
download "json", "2.1.0"
download "msgpack", "1.2.9"
download "cool.io", "1.6.0"
download "http_parser.rb", "0.6.0"
download "yajl-ruby", "1.3.1"
download "sigdump", "0.2.4"
download "thread_safe", "0.3.5"
download "oj", "3.3.10"
download "tzinfo", "1.2.2"
download "tzinfo-data", "1.2016.5"
unless windows?
  # Gems that don't need to be fetched explicitly on Windows.
  fetch "google-protobuf", "3.20.0"
  fetch "grpc", "1.45.0"
end
