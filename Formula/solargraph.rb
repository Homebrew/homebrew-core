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
    sha256                               arm64_ventura:  "d81291ea3c9fda5358b963e12fbc33480755605de9631fe030ebda2ffba630cd"
    sha256                               arm64_monterey: "3ce57d41d103c0991523999d5e52f6514e00ce42881afa21770a70964afecc02"
    sha256                               arm64_big_sur:  "89beb80b2f179869286c4ca981eaf55f72582a8289aca33c728f73357dd6d465"
    sha256                               ventura:        "2de083ef48c67163e7c2255bdba398797ad59c2c77d0cce10210060156b4b361"
    sha256                               monterey:       "0137d12c253ff5e44ca3591084cc4a143ce8b83ce3c9565efbfdaa6060478df9"
    sha256                               big_sur:        "a32ae970c5c58d9f6cd603e2ae79a417fd4bd406116e125478eef77efcd8d3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18ed50b3d5a27dffd4c381ca00e923a029616271527e658764a93e0b207b5a7"
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
