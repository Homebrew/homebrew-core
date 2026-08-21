class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.11.tar.gz"
  sha256 "231ed17b9c011361da26ef49b7cd9b75224004398ac0300d104b1bb38f4c6d82"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a2657266d7789dcbd73ed6a13edc8b758194c331efdf7c3275e036dd0ad76026"
    sha256 cellar: :any, arm64_sequoia: "a17cbe307f049ced6f4f392e0f20ad38c9c06a2626279779222644d07c22047b"
    sha256 cellar: :any, arm64_sonoma:  "6ec3d80517135aea1e43bd7f39d86750ca4da885031a8aa374c9880ee365ed56"
    sha256 cellar: :any, sonoma:        "b52f860fbf07d8adcc34c2901031a6b8bd27bb0ec64bc6a2f3ab5c69296bda5a"
    sha256 cellar: :any, arm64_linux:   "2cce480cb81a661a0c8f7a8ec70a5a0ff8df45fbaa8bd3c862c0a514623839c7"
    sha256 cellar: :any, x86_64_linux:  "de5c6f2d78ee28e2f9c9cc69fdf77d3d3c64ea18757cea6dacca93593b6b2c7f"
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
