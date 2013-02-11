require 'spec_helper'
require 'net/http'

describe AmberbitConfig do
  describe "GET '/'" do
    it 'environments from HTML content and settings should be equal' do
      port = '5555'
      envs = %w(test development production)

      envs.each do |x|
        ENV['RAILS_ENV'] = ENV['RACK_ENV'] = x
        `rails s -d -p #{port} -e #{x}`
        sleep 0.1

        url = URI.parse("http://127.0.0.1:#{port}")
        source = Net::HTTP.start(url.host, url.port) { |html| html.get('/').body }.split()[7]

        pid = `lsof -i :#{port} | cut -d' ' -f 5`
        pid = pid.strip.to_i
        Process.kill(9, pid)

        expect(source).to be == x.capitalize
      end

      ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'
    end
  end
end
