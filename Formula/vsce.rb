require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.13.0.tgz"
  sha256 "35ff4da00eda97ad8b243e6562988c98e6ef981f29c849fa30e66cdba55babad"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "648964f97464501a29bc51cc1fe44b66b533cff414ede923324d2c49148e1f2e"
    sha256                               arm64_monterey: "9d761b3a7cc0d1d52e7b08dfa55b1fb45efd7abb9acbfc20e6867c13a1caab9a"
    sha256                               arm64_big_sur:  "e62ddca8586ad21ce81eaea7643249feec86ae63ac1cf25f079568fdcee09087"
    sha256                               monterey:       "2df96758397d9649de75cd3c28008a4e9a31b6bb4a16e074b044176b34b74525"
    sha256                               big_sur:        "08cb0d689cb950c98cd4b9c1c9de0be2105c3bdfa738c887b9878f62d58a267a"
    sha256                               catalina:       "88331e1448330593b26abbbfe3d85d10b5ba80e87b5c854ac253d865c7dfc166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5ef7074e2311aa6d020f17a18f4a808985890edd768d20abfac1eae1f88b32"
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
