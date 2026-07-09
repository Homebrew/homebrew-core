class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.10.tar.gz"
  sha256 "32225c7c1ede0862b4ccbb6fdfff0d79ef16e972d4d7b02e54e8aab6f94351dc"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0b762ef09326a2289410c0267aa8d1c03c8529ab98c4e23274e3d65c6398c75f"
    sha256 cellar: :any, arm64_sequoia: "d9375ca3d3db4eca1350fc8cdc79446594451640fe3e3c020d7c60db64cd7f61"
    sha256 cellar: :any, arm64_sonoma:  "5f99f0c5508d3da1546981ae1e0f1473b9411613a8e2ec6258d42343aeca0a3f"
    sha256 cellar: :any, sonoma:        "56930988db8ced43ba98cceb2951fbfd16e8ec8a1a6739b845375a8e9be01f85"
    sha256 cellar: :any, arm64_linux:   "09556fea1439ba96cde8a94307cee0a63b7957e17369be572f3ee1d59689ec08"
    sha256 cellar: :any, x86_64_linux:  "f68acbdbf42fe2834e0d8289b85e4fb83ca9fd435989e2764292fa0b64cf6d4c"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files libexec/"bin",
      PATH:     "#{formula_opt_bin("ruby")}:$PATH",
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
