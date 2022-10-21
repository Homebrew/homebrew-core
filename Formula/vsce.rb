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
    sha256                               arm64_monterey: "c9d4b60cb3c2c1d49a9e254233f77fbca10df07f184a6baca8153b7c85ceba82"
    sha256                               arm64_big_sur:  "e632a897b30b82ea226f56ec8c62148fa37a35f981a75841cfce53edfb219072"
    sha256                               monterey:       "8b4c1dc87c7957ade8c88c0b53bb75efb40597362aa39bf442cf17b73c75343c"
    sha256                               big_sur:        "20c72f002c77aa3c65d1f7611fa4eba77f4becf4f40a42198a56e2a1923b6355"
    sha256                               catalina:       "625ccb9bb941b5b10369302766395c153ee5a97b23001bae6947c501e56b19bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b35c9b4a97bf9c8a4750c3b3374bb8b09c572b90dc3edc02b66219ed2b1560a"
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
