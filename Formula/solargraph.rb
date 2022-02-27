class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.44.3",
      revision: "4ac21c95ef3ccae100f2956a20aa90fd1bedff5e"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "a54f53dad171c5621b4d14fc4696580eb5cb40d61b851644cfc5a1dce156435b"
    sha256                               arm64_big_sur:  "f2d635dd863160e24a10d4d90db18e6f166335a6fa0a23f7c30e3560b698917c"
    sha256                               monterey:       "678c2dbb27e90671dc658ca58af29eaa0af24835368a0b9043daf551d67f6f27"
    sha256                               big_sur:        "b9a7df028d7c6a1dae8db9e0b9f5a2ba05431a854c2a7d6c0a6d65b84f80835a"
    sha256                               catalina:       "015655f02883f8192893d617ae44193acf2a4b101aa732ae0d969bfd83237d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71e2e9306955dcd1d6645f6776c7b2ee5c7a1128038970f3f8d7315408bd4563"
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
