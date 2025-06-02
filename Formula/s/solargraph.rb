class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.54.5",
      revision: "5c12a117b50b739826d08dd4106ead4a99d6c98e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3ddb4c7d98022ef041ddba83e0c7d29c9f812ea4c63c1cdc763eafe291c7cb7"
    sha256 cellar: :any,                 arm64_sonoma:  "1d2ab09f5e4dc9b6d77a3c00db8d76dc1704f5deae31d061aaaa76f88180ca60"
    sha256 cellar: :any,                 arm64_ventura: "9ee2429f6b8dc968f926b352df8c2f816d840aaa881722baee5488e1f79743be"
    sha256 cellar: :any,                 sonoma:        "0826ac7230c2a94be08cc16618812a317f73c8d5cd330f17637a696694b1c98d"
    sha256 cellar: :any,                 ventura:       "5a554b737eed277748188f885a070847e528808101d33bedd6ce2dbe4dbe203d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4dce58bf427f728e03653bb67898245514a9f62296ff0c3a4ab4c2147fa99fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a85d427d18d3dc88e7c70ab0b93f1868b9463ba6aca91a0e3997a43c200b73b"
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
