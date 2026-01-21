class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "ee9765866d2c4e843acf3b434a332142513bba4ada54d30fd68888a1a60672c1"
  license "MIT"
  revision 1
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "265daaf7d05be673f818daf1549d7560c634646bbac1a309241f9716c53a8ead"
    sha256 cellar: :any,                 arm64_sequoia: "94a42977c366b99cf9bc685227f09bcff0727552013ced926586e3f46a8d118b"
    sha256 cellar: :any,                 arm64_sonoma:  "f61a296b6b23562030a13c7dd7eb3908b1a6d8e9026437dee26ab640b8e46d6b"
    sha256 cellar: :any,                 sonoma:        "dbc8afe80b4631d787baee3756b7453c8fd95c72ceeeaa45670a94fe309966ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cf8c0154725e0a57c2e2b576590a920ac5b6a5e4fc797e36a4ad6955aa757a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c23a75d666c5fa871f2278b1e8da6327b48306eb3e26d015a75d9be88297dc7f"
  end

  depends_on "ruby"

  def install
    # Support Bundler 4.x.x
    # Upsgtream PR ref: https://github.com/Shopify/ruby-lsp/pull/3823
    inreplace "Gemfile", "\"bundler\", \"~> 2.5\"", "\"bundler\", \"~> 4.0.0\""

    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files libexec/"bin",
      PATH:     "#{Formula["ruby"].opt_bin}:$PATH",
      GEM_HOME: ENV["GEM_HOME"]
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruby-lsp 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
