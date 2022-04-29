require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.7.0.tgz"
  sha256 "68016d50a3208624c525dd8d214ac81fb37772d94f1565740a2e9d061a25327c"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
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
