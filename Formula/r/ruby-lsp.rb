class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.23.14.tar.gz"
  sha256 "041c25747d333c5aa934c527815a95df990a0ee1c7d6e489c381257b8b4be8cd"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "05724d0ded76624312479f0b6d0bcd85ca023aefc29072cf2eaf36bb960c510d"
    sha256 cellar: :any,                 arm64_sonoma:  "2628d368668c4a1fbcecba0d8598815e142099b1ba287909a89db5630984c1a6"
    sha256 cellar: :any,                 arm64_ventura: "3a099967f1b48028c39eb5ab8005f517ed5d1cfbe66a5e173bec4a3ba60c2c3e"
    sha256 cellar: :any,                 sonoma:        "4a8d77c09893b1297c8c3cf1c5ba5032b2de178a2cd9ddad074c6dfaf1bced78"
    sha256 cellar: :any,                 ventura:       "9b4e7823632f81d1fb9cdbd155884251d02694af40da33d2328b96330c766f71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eb25045fb6f575f023e472e1235c3c88fb3cc0db69492f07b8825fb349c6825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a07b5d8a001218ffb986049bac489988f7ec6ae2e4e9cc725e884941b076915"
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
