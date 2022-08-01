require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.10.0.tgz"
  sha256 "af3e2e8aaf5d59f27d123762aadc3cb59b3afedfb3a6f9be11be2b546b80a368"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "124444548868453bef200e1e26846fbd15054f8c5915d7a19def4e36aae5d6c2"
    sha256                               arm64_big_sur:  "f274fda85e20c41480b885e82d15ce20a459baf18203301d460f61a185ac20c0"
    sha256                               monterey:       "30a45a6780fac9de2e08028394db17bcb99294f265836a711ec0a8612102b868"
    sha256                               big_sur:        "69c59898b3ad77aecc323928976b9420dd7a79f8f1062c67e3c6979755921fca"
    sha256                               catalina:       "8aeea5dea401ffc23f234e27b0b2d5740c3a3b4e22773c613afe8e26025a8aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9388ec24de5d42c383546ca1eeaa93dbd3a1346d4cbbcc388aeefa7abe0eaed9"
  end

  depends_on "node"
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output(bin/"vsce verify-pat 2>&1", 1)
    assert_match "The Personal Access Token is mandatory", error
  end
end
