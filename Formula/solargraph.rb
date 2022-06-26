class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.45.0",
      revision: "4558cbdb249952662a565c4220b7406f3eac7aae"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "4b6130b79be7efc591970ca5c7404c1efb27e0a7d3626cbd140a68869d490c0b"
    sha256                               arm64_big_sur:  "3829a09b29ee0459b26793cab4bb70302607ff72b410ccfd24089060184a2814"
    sha256                               monterey:       "7d6d32dec24c06acd8135ff5c95d4fdfc70708bb1b98da583ece2a504b25c497"
    sha256                               big_sur:        "6fe09f971cc5729190ac8b3fd4ef414b2b9e7f255e69e7b9ffdf086290555073"
    sha256                               catalina:       "57fbcaf44e83863fec3554c60f5eb9e63eadab213d76bd8df3f4444ef3b21ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90debc6325564ed50049334c0cf92891b12a8b9eeeb751977b8b764267d24300"
  end

  uses_from_macos "ruby", since: :catalina

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

    Open3.popen3("#{bin}/solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
