require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.8.0.tgz"
  sha256 "eca227dce6dba0f2dd32a095df5aeedacba27a7cac14278e32e3b05e9279ca11"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "1dabb76db108654d63617e2cef4860bc08f83382e166b3c35a96133679b34826"
    sha256                               arm64_big_sur:  "05ebbf7c52dbd529b59e93e76ca89bf3dff43fec88ed3299ae4897fd1d63a30f"
    sha256                               monterey:       "147f0e7a8d4ccc2bab0b72944da116174e68776c41431f1391c3535993e843a8"
    sha256                               big_sur:        "3df6acc73a85fdd4a984769db7078d89f7e84ca88ad9457f66a1eb822f271f05"
    sha256                               catalina:       "d4ab3afb6917421a15cf4d1930f6b52e5bc998afa0a8cc6db6247cd9a7255a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af072b9b41dc84f661ac2a66935ff551d3b90dc4637bd15e0fa5de057a73a2d"
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
