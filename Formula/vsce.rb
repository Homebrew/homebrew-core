require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.9.2.tgz"
  sha256 "5490c598e0bd298c973c520dab958c18eb10d18cb94f03b5a58c71c3380638a5"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "af14d29ebf430067f1024ec51e1a1e2ad292c7b18b59cc890ca73ab83f05c4e1"
    sha256                               arm64_big_sur:  "8308762d2062e3adf1967a4605429f81082ed9f1cc6b5d637a737b21377b3d9d"
    sha256                               monterey:       "0d891495cdda6281edce3ebd72be05fc49792904acdb4f732709f78e50af5e0a"
    sha256                               big_sur:        "173c8517adac2e1534a807ba852bc49db9bce0f60eacff80f255bb50718fc7f0"
    sha256                               catalina:       "fb3e60bb4ff15de159152ec11523dcfe7be53ed74b8c1ccf9d3a6e012340f4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9590a306c4ee40176caef689dbe12a088e3772309476efb49053eafe366e0573"
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
