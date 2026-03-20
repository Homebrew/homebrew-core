class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.8.tar.gz"
  sha256 "e152af85830348971bfd46ceef9709b531c5cb3bb90febb5aff2b111dccdfcfb"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ddd35e878d6a335d5c71664f1cfffb7d40a180f705535f9facd17da56c06786a"
    sha256 cellar: :any,                 arm64_sequoia: "e9c4bc2fbd30950d032019495b69b076d32cd0be54f958ef2f994ba547b313ed"
    sha256 cellar: :any,                 arm64_sonoma:  "545117d236d7cd98a08773e105f248ae936ab9b56452dcb02252d94a65d7006c"
    sha256 cellar: :any,                 sonoma:        "b2b64fd3be168c2bfffaa96713963d3ff955a12734cdf560faac0be83ebb6ad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a9b9ffe511c73a344570b18d1eb30a914c342f179d1bfac81dca58241b47a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cbae600afa01ab34b97c2bddaa9e9fc0453e0202b574aa59f2633cbf5488cd3"
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
