class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "c1915b509bc194be9d738ee09b648621648427c8a6c0e9ffbb5fe1dfac13a119"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e90bad7b0c0c20518fabc30ff2f4c57a19c2c53cab7dcf9b1c24ba5df06ac6b"
    sha256 cellar: :any,                 arm64_sequoia: "4fdcc04ac256f4aa1554e538209ea01c1cd437e0b381a72fd61e10b04aedcb7c"
    sha256 cellar: :any,                 arm64_sonoma:  "99c5d570c3eee1c4d074a69f3be25a9d94ecbbadb652b460734403e35d7613ab"
    sha256 cellar: :any,                 arm64_ventura: "5ba5fc1a547a62133c30fc6b140e1200912c9a2563260a19483d9c034c312858"
    sha256 cellar: :any,                 sonoma:        "940b34a8ee67e4b04d3e08982c87968fb0e71c6c1acb0d254dc43a7cc05b46a6"
    sha256 cellar: :any,                 ventura:       "3c6fd7cad0cb72528c2728065aca4e7c98138cf6afa3d953ee2fcd954f4979d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "510e782ccb9993b754e63a69410a909072acd982e4cfd91648881a70cbf7be35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6870ba38dd02e68c3f25bd2f687a780dfc3b02615e0c8b1f7de96d9dc21717b9"
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
