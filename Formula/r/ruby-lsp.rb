class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.23.15.tar.gz"
  sha256 "0ba06ecf8c9b83c0aecfc6dadce57b8fdbcc15f14f4be60db488519eb943760b"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73459e9e2ca740b84b6c0914dfff440284c571e5b6c087337ebca92d762ce240"
    sha256 cellar: :any,                 arm64_sonoma:  "085acddcb421f759c650c61a3cc7bd500c0d794e90ec6e2e52b548b95a075434"
    sha256 cellar: :any,                 arm64_ventura: "8436aa5db02039b9c2522c34f83401474cbb678ccc2cbb37db89abcee531853a"
    sha256 cellar: :any,                 sonoma:        "33c6b1b9fc2e8b6f7b926203e8d161af5c20ebeefd999b4ce07afb3592b38d7b"
    sha256 cellar: :any,                 ventura:       "66fd720f2e2f0828a59bcd99e5172ec8c437eac4e4ae694fe5703e2af0060ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2cfd6a52d8282e352a9d954691c777cca291c04e0face1fc44b0798c21a7a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5735cd96e274ebbbf09c92bb2dc01289660589c66cd0590ee748cb3bbf29746"
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
