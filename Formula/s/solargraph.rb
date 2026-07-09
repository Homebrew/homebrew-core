class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.60.2",
      revision: "f75f56277f7a747c0d4a83087b4abd93a2d90f73"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "92dc2e6691f5c5c926fc3ab20da8551de969ed6776e5c7469b548be1f5847e87"
    sha256 cellar: :any, arm64_sequoia: "9e71fa963b543d7c35670fd4d56667499c16461d1c91964b884c83c620a4aef4"
    sha256 cellar: :any, arm64_sonoma:  "9c418c56de8fc30c31f65c99074619411b2cade3e8c0aad083b65a3a4104bd39"
    sha256 cellar: :any, sonoma:        "8c4b784f8131f0f86c8dceb96868b0507f32c24d9603fc9e3ddd3825a7cdcc85"
    sha256 cellar: :any, arm64_linux:   "bba1377405064d5f70c3c4f5aff12fc3bcc736c6cbbb1caf31d977f8c7276985"
    sha256 cellar: :any, x86_64_linux:  "6e983e602cb29631b9d8f7ae3d4bfdbaf06f46e1172c9e98303327a077a967b9"
  end

  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
