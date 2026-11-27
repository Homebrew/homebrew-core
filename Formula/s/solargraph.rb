class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.62.2",
      revision: "78fbc880f5cfce587071bb9488be0fc7b8d7acf2"
  license "MIT"

  bottle do
    manifest_sha256 "88bbf141e50f792b23d898702784cafb5c1b6e0128169c31abbb38e7c1723923"
    sha256 cellar: :any, arm64_golden_gate: "81546deaadd922af1e488870aaef46bd06d44946dcec872e4ed9db10c0ac8d84"
    sha256 cellar: :any, arm64_tahoe:       "cfed1245205099533213d558fb48266981b6dd0a397851cd41cb3234fbbf7ab6"
    sha256 cellar: :any, arm64_sequoia:     "beabc63948c42f1e39f030a722c788963a755085df740286578eec2b3beb4c8d"
    sha256 cellar: :any, arm64_linux:       "8a3db410265f46aa1132722e92a5449aa1285c65c2754249ecf418e654a75724"
    sha256 cellar: :any, x86_64_linux:      "950cf7929b74c28e089a0e47d67b9c043af6d68a18ebdcf1377ee0856b8dab23"
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
