class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.62.1",
      revision: "42ac0f358878b90f482abacc0ecbe9ee8a390063"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff6f5114ce0609add9042425bf99c1506de1ac72616b983707a180e6faf793a6"
    sha256 cellar: :any, arm64_tahoe:       "e8656adc12bf19ebf13cfed2ccf51b7035ba6308c6763badd2c78b7bf8305214"
    sha256 cellar: :any, arm64_sequoia:     "fdc892886e1707f0089c3d34137fb1f4faab27d61aeb3a92da0093e75f488429"
    sha256 cellar: :any, arm64_linux:       "2f959e553eb46506644beb61e4c6338e29f9c585096357a03a44cb92bde0bdb1"
    sha256 cellar: :any, x86_64_linux:      "6456d0909795b9d152a047438c3636c4f968d07d6c20d78d5d3d06f87f217bb9"
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
