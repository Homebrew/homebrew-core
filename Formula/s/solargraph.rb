class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.62.1",
      revision: "42ac0f358878b90f482abacc0ecbe9ee8a390063"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de81dbc4c182a13dd7c642be454c3b6fae130af768ab011b1bb2bf4158e73574"
    sha256 cellar: :any, arm64_tahoe:       "a2da1dbab40f4b2c5d5acaed65c0bc252032fdcf709d4c1c5811b6bdaac86532"
    sha256 cellar: :any, arm64_sequoia:     "705949fc45d7f5b1edd3763fafb8e043fd1286c633840ea705fd7202f2b5f634"
    sha256 cellar: :any, arm64_linux:       "76d4338a4a3d6b130916bff62a42310faedb6237a9792dcba480d28da9311a96"
    sha256 cellar: :any, x86_64_linux:      "a6c4ca0aa7da09af70fa5700e77d57ead5c2141cc0ded52e58ea099eb57c86bb"
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
