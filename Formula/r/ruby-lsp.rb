class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.6.tar.gz"
  sha256 "62fa19f364b55d414599a4c55039bce6c8abc30645bf7c673ba3446834b66263"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b42f43f245fb31a865acf06bba21607a837d02432d67037b52e8ffc223399355"
    sha256 cellar: :any,                 arm64_sequoia: "4def79bd8c2bc3ea7fe5fe5a5fd4db30b658ff51923c36c96c8fceea341b61f5"
    sha256 cellar: :any,                 arm64_sonoma:  "b80e95f390bc8d4ba1efb1ec13f4a9b176ca2e153f5d19f7527d87d0c1510aca"
    sha256 cellar: :any,                 sonoma:        "0797248feebf89a30534df0933a6b3b31bcf9a75abf8bb6b480c1fa23bcbc678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f40de6abdb61e86ff76613b1c44e9ae8c9b41c2acd75c91c30d5b193a6f6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1703952e0368add0e6386e1d3e5057bfeb5eaafd497bf9bc4176bd3126c982"
  end

  depends_on "ruby"

  def install
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
