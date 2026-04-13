class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.9.tar.gz"
  sha256 "dce37728a674194f27e5a6565adb298cb10ab7f7bd8bfbed60180fe57d0bc64b"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70e906ca86ab7d544c64e5c5c8ff5cb6c753330da919149c0da47f4a607efd3c"
    sha256 cellar: :any,                 arm64_sequoia: "c892b43193f13f0ac62991a8f14a0226e688392f41d86426c5707f34e6e9dffa"
    sha256 cellar: :any,                 arm64_sonoma:  "660ea01b712675baea507d0658d4f8fee09d6d72a4331f478c895afc3a2c41de"
    sha256 cellar: :any,                 sonoma:        "eb7487772e9435ffd6ee57a12d01f8f94795aac8a329dafe05b2baff9f4dfb4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e67d8ebb4b705aed8fcd747dd643076a22fc47b926e0d3ca98cc45319233039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f249b8e92c21ff6e78972874d89a087b23741e78b94fbf526fd0922702ef3926"
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
