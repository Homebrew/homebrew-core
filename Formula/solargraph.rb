class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.44.3",
      revision: "4ac21c95ef3ccae100f2956a20aa90fd1bedff5e"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "fb2d64a97289ed55cbbda7e58fd2deb65681cd33401295613733e7c654456fbb"
    sha256                               arm64_big_sur:  "72f1135e0d8ceb77e4bfe84dc61ec8e8f82bb483799a0888df19a0685384264e"
    sha256                               monterey:       "5d041394b5e3f3d74cb10bb196007547fe300d8cecbcd404aaa02f4c3b74922e"
    sha256                               big_sur:        "d60569c6fe265aebac155db50bed8d7afe292cc8e8d994e52fff45f8b342e58c"
    sha256                               catalina:       "d913d62fa820d99f1f5c75e27f969479371b2cd12e5b5de52160885e317e22b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2251244ab5e365ef8c5363aecaf8b79dc0a5578bd21fa900fc7fe4f9a04cd078"
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
