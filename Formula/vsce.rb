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
    sha256                               arm64_monterey: "e5a7376992e94aa8976d1d93abf15031320f29bd9f0beffde9429ed6ee99bd58"
    sha256                               arm64_big_sur:  "150b93867c97d0bc5fb51dcf5549eed6acb16b938118b3dd2e43231f767dabde"
    sha256                               monterey:       "0f594a283f3375a08232c3d4883fc756d5e946f87bd1f5f4f55552801d8bd7ce"
    sha256                               big_sur:        "24174d6a1e6135544e00568d3d76366e46d02f115b0aa16f26c909949b86c24e"
    sha256                               catalina:       "dbf82096b1021000d3dc02c83885a33f205c9b30c24840983457fbb96cffd509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3416dc6414061e4e6c391f958cb45f9916f2dc11206f656e38ccf1f5e94237a6"
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
