class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.51.2",
      revision: "f86dc1c908e8e54e665accb8531c1f535e3b0d87"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "055dfb6268fa93c530c653e78393504356b9c6dc137cd5ac73e44895d6006c3c"
    sha256 cellar: :any,                 arm64_sonoma:  "b63ac5d5c7e5948c1d588f4713dbb4671a72b1ca18f3b49cb0bf23d750d681d1"
    sha256 cellar: :any,                 arm64_ventura: "06860f84eb44f9addca3e61aec95904c4766186a3624daa5711a3c2da0b6dc2a"
    sha256 cellar: :any,                 sonoma:        "51bba6b6f255c9630b211bca622357f8be953b555d14487f1654e4645b8bf5a7"
    sha256 cellar: :any,                 ventura:       "97af4d64cdd227870688e78f85daeea4f548d41c1b1b3c4e9ad5ba6cd6d45aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b083fa6cae88dcd1109efe0c920dbb5834a93d013bf89f21655ba7dfae4cedc3"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
