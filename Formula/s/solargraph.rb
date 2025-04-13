class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.53.4",
      revision: "390a1b766cf1933a3f4bd35bb6c3cfca7edd2bc8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c444b5ba211db8d50e15e5766270700a83584cd5af79205c1a9bb9fc0fb5d91"
    sha256 cellar: :any,                 arm64_sonoma:  "504665beec0e6cd6f74d285de31bea80b4e30250b291c3d4e3b317013586c016"
    sha256 cellar: :any,                 arm64_ventura: "cb792e5c2fe26be09e9196000e982e502eb56aa4fff641cb2ec1207de5847cf6"
    sha256 cellar: :any,                 sonoma:        "cefce402c8eb6c868725e26ffb54e597bcb46b50409d7b7bae5e8248445bc527"
    sha256 cellar: :any,                 ventura:       "7943b09d7795a048b46f2306d56de9fa0179c56e9a7acd2184b91197dd1ee329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b191d120229d210c82b6363dee49cece5b79871a1f8c22f1c482b1a538a3f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3545b209b6370df2266e2a610f5f0255acc003283b018aafff5dfaba337cbd4e"
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
