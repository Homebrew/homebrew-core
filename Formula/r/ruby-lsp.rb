class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.23.23.tar.gz"
  sha256 "57ace306d44850658593db777630f574c4b3684612860806da4f4473b7f7e0f9"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2fd0c2b73be8ed2bd5914eebe81475b738621349b32b74a80f3034ca2dd2bc3b"
    sha256 cellar: :any,                 arm64_sonoma:  "5a6be1cb4edcef2a338e7c6dc96efad26fc9ae7c6ed4830976535475a9025ea5"
    sha256 cellar: :any,                 arm64_ventura: "0aa242e225cc970d0883c1e145e58a556220d786e40f0f8af547ebd738114ae7"
    sha256 cellar: :any,                 sonoma:        "5150dc500281c6444d6178eb918f538e4088719862d6d538ca3d7c73c79909e1"
    sha256 cellar: :any,                 ventura:       "b714ce31cf1554d03404540a56ed6bc9ff43ed8a491380bbf72635c6cbe923bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff6f2121f144b532b833d2c43dd34eafe1b6998439a80814127fdbb6296bb03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31238c86b18eefb542db05a433847ed93e5ec47bbe5c2a2974a54ccde0b48a7f"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
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
