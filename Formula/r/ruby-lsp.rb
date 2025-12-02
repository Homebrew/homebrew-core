class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "ee9765866d2c4e843acf3b434a332142513bba4ada54d30fd68888a1a60672c1"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03eb830ae5d95418fadac01f8d66ac151438154d6ff9b7ebb56f8b3dbf91cc75"
    sha256 cellar: :any,                 arm64_sequoia: "6593266c6e540f23a77836804953eed577c54bb10f9d56448f91838294672fe4"
    sha256 cellar: :any,                 arm64_sonoma:  "72ecdb56d89268de71c9e7e1009828eba6eb84f72bcd01b412e14d6db66b5dd8"
    sha256 cellar: :any,                 sonoma:        "e549c74ac122f852ca7c1d5fe142411d6013ebdfae40bb67f6ac3a31d8f2df97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de5e2dbf7725a9259a231ac6f592d332d11af0ea3c3d4ff45886f6df35b6b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "235b393ec63d2f23007c6cae2553730212214a2d8f6a14833e0555f96d3e6756"
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
