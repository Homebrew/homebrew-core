require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.15.0.tgz"
  sha256 "df4dd4002ad13c4787d29f4ced37133970c89db04af1c9041ad14b279b2a722f"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "7f4a3b3b9f799b1a9c9512d7ef494b9824addf2a905eddd82e64bf9d63144442"
    sha256                               arm64_monterey: "bdf14a9463ff09ed539eb806fa32ea0f696211393b63b0e863c5fd84b3b7c9c4"
    sha256                               arm64_big_sur:  "a2f3f741154cf72545c2040069ef9b46bd0bbf1dc5fb2a44d7e316b46459b75b"
    sha256                               ventura:        "8a63015f35cb184f30152a9c6436a49cbbea4d69360862dadd7727e6cc78f8ea"
    sha256                               monterey:       "58550e96cc292bebc2f160606a487dfe586f7a1f1b420ecdd9f834cd9a6f647f"
    sha256                               big_sur:        "d663fa67753a57eb4a82253bffcc7ae2563a0b8721e3ead316554ac7c305e830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f848e56aeabd87e89ccd59771bfc6a7e5fb165d3b942b1cd75fc59d3ed040727"
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
