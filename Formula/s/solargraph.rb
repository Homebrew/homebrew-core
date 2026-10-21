class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.61.0",
      revision: "01e9bd8277634144b5fb4fe8d83eb24a9ee251c0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d73fa278dc12d334dfb24917305aee193da8895b4fd092659466d0bdf9385109"
    sha256 cellar: :any, arm64_tahoe:       "fc35102e0a80d9805fdd32e568b00d4a218826e2e12f19cebd984ae0e7b63ee8"
    sha256 cellar: :any, arm64_sequoia:     "10da234208f325acf4ad781d52c0ba84bd8a66578e6520804aeb455e20aefc8b"
    sha256 cellar: :any, arm64_linux:       "efd16fded4a05165e4bd02d3af0f36d9297149db1bc4f608c9a86f0664c9bded"
    sha256 cellar: :any, x86_64_linux:      "8bdb582f9dbecc2577464045fff07b927d20e4c20642b0e67ce1aae136a56bcc"
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
