class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.49.0",
      revision: "c8d40adc997efc90eff1892a0e161543a696d358"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "b3809485537b507bea73604022f07310f08fb484d3179c87d87f680bfc6a1445"
    sha256                               arm64_monterey: "d7ec8e0d4f845d6d097575cdc393d97d6af84cb43fa9fc5f9158b8ea52998c08"
    sha256                               arm64_big_sur:  "9d6ddafa53ddd8f1dd57757c59bce35388b11ee96521381bc3c9087483416235"
    sha256                               ventura:        "7303e3bb5200c0a76efb7413c521685e8283e7654e83fe809c75c456d5363b67"
    sha256                               monterey:       "38382e8d0266c38e0eb6fca8176477026d8ece5c53237920cd6733f3b90365ec"
    sha256                               big_sur:        "c2ba1e2a6e9e6034b9c30e680bfaec1d143a09df6928c70e34b0109779fbf712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faeca34a6d2716350ec139ddaa22993fc65ce2cd01dddb8a3d8098a21be5c358"
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
