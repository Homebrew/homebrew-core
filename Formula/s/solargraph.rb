class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.50.0",
      revision: "58f3b8d0f31a3bded0b1cdbb6b2934eee262f03b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1deca10c6cdef6ffd6b11bd15f9cf0db603e1558efd3d3dd74ff88747e25f38b"
    sha256 cellar: :any,                 arm64_sonoma:   "adf2c964dbf8a6e8e6df15c78a99c7635cad6a8e29eeb922e418a135f414c38b"
    sha256 cellar: :any,                 arm64_ventura:  "ac3502934bfd32481fc7bb267318ac17fa4a1f4c4f87d83a1226c0fc7b84243e"
    sha256 cellar: :any,                 arm64_monterey: "a5d150ce559e3a63e7c2cf8cacd0b693ecae7d3a0cc4053ab4bfb118ca55e8b8"
    sha256 cellar: :any,                 sonoma:         "9a0a1f7fbdbd210833a3fd49228457bb49d73df9aaa3255bbdf539f40bb5755b"
    sha256 cellar: :any,                 ventura:        "7c26cfc1b83a167f245b25283fc9c15af0083605f4a6e8a188932466efe3ac32"
    sha256 cellar: :any,                 monterey:       "77c8978cae979848b8caf92d1a11c9a7bfa64657b2b27fdedc11d2584a2ec5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d017f532d294cfc9a8d42ec0997e89117b49d6f9457cdfb0c69bf1da2c88c2"
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
