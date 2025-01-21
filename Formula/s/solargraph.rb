class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.51.0",
      revision: "5b45ef6335df2380ab418fde9eba623a9bdc7928"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d722f865c26f967c1e74bf49c0cc41ff2a1ac80f496f86c5c8f3bc0af7999723"
    sha256 cellar: :any,                 arm64_sonoma:  "1810a84849e0732449acd975ac5289f274f6c8fc74d9b7e0b7b29ddb45c11188"
    sha256 cellar: :any,                 arm64_ventura: "aa6397607bf5341a03a19ffb77e2a6faced469eaa108f5fad79ccd21d332ec7d"
    sha256 cellar: :any,                 sonoma:        "d10c1b12b33a7e6de08d35b27b20163c1762cb8a2561037886decdca9d0e9980"
    sha256 cellar: :any,                 ventura:       "86666e602898b35730449d5e120cd9f0861bfda405132ca1b45e5a7693b75db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e361865612eed5a614cbb2c485df60784a464f0f1f144bf7183fac96e68f76c6"
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
