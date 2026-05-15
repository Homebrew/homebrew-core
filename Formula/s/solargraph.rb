class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.59.0",
      revision: "6d8ce9515c767c9687e4a6dc9ea7f077b6451cfa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f3bdcc25dadd3d743989814c89d456c2a1170cbd9c2c26069e4ddc77e6811dd"
    sha256 cellar: :any,                 arm64_sequoia: "0fc542d103aebba9d223f5b4ecce57075e5d9364603f8da99da60a06e6b8ab8e"
    sha256 cellar: :any,                 arm64_sonoma:  "16f84b1cb90e776fd2020531d001571b6048d1812b4d114e92be697d8ffb4c87"
    sha256 cellar: :any,                 sonoma:        "c9b7acfa11f01d66c9d85982d366af508abfac3e7c6cbcb2ddf5d54dc20af26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4930ccc17e471736033ab3ab720eb4d34a2785321608e9c29952520c16b5385d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b5d7bb6bc324bef0a18481cdd305c0d0c483a3428258edc79f3c2d239325bf"
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
