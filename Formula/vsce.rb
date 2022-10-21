require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.12.0.tgz"
  sha256 "1ac71ac1870e76015ba2d36e1e5713773935c0d794e25e269a3bcf431f72aca4"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "0798c8eb757068d60f115ec2c740046e6c45b62c0d8278300641a398b1890183"
    sha256                               arm64_big_sur:  "0c188e6625e1794cc8c94b29ec8fe44a5e888bc7358294d1a79fd5881cb08ff3"
    sha256                               monterey:       "8759946a2ede277f7d916230a200052e4f707ee7b91b46d30d36d39f98fa6433"
    sha256                               big_sur:        "f07f654f4f2b1d86c39b6f3803d7af29a078c59ccb94621d59d4e71e47f3a874"
    sha256                               catalina:       "67020af8705c6517b77937839f6a141c53e05aa7768f151c4cccdbfbb03aa3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd13f6ec21694aa3644510ec70577cc81730beaa33eec0481fdbe3cf5fc9510e"
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
