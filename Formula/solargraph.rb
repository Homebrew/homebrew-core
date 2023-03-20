class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.48.0",
      revision: "d498612c3335457464c20480b3b22bfb687e9a42"
  license "MIT"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "19aae494ddcd40f80c72a4ec3c98fab4ff5831c4c6a500e035e1b648e3968d06"
    sha256                               arm64_monterey: "17a8947c8f83f193f3e8ee70902b647f5d63bc342902d0b5bd130ed9367652c6"
    sha256                               arm64_big_sur:  "747fb16e3f3aa4a772322349521af539c9378f38a5e5d517b4dc405a93226b43"
    sha256                               ventura:        "480a88b17aa102d20b5cbfe6130a0b740328217e3205e68599bfa6c0ea58dddd"
    sha256                               monterey:       "8ffe7bd88c07052c8a0646e6d03658f9ddfa298013203ca06f44ca1e116463c2"
    sha256                               big_sur:        "28768ad1041ad18df04c85a81754226911ac79e4a48be26dba4ba05808a80f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e554c13221a7ad25a8c07291573956c12a9203aebb754f754d6afc2666d177e"
  end

  uses_from_macos "ruby", since: :catalina
  uses_from_macos "xz"

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
