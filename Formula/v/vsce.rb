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
    rebuild 1
    sha256                               arm64_sonoma:   "48d0726cf723c7bc8a7cc6dc70ac7264acd991fb754d3f532221b30f46f69b06"
    sha256                               arm64_ventura:  "0c6eb6b03b64e309d96faf44d2472a96d7fbcd3f6159530f46dd735b30ebd8a4"
    sha256                               arm64_monterey: "3095ea99be11fdcba4cd2e1c5e347c6a11b68e32c401fd0e361262e0328b00ac"
    sha256                               sonoma:         "afe4a6cf108c2aee2a672a8dff18b1161ca6c66da40a95527f366233000020fd"
    sha256                               ventura:        "aad312e494c4dab3ec434fc833fe4d3390a0e2419b2ab4f9336cb43aafc1d318"
    sha256                               monterey:       "d6d5b20923a47882415980fd659a0c3b5313811fa747fba41ed47acc2ab91dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ee6be7fadd75c972f68455ac4c3c75a9fa7f8de4ac1205dbb80df6d9889e66"
  end

  depends_on "node"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output(bin/"vsce verify-pat 2>&1", 1)
    assert_match "The Personal Access Token is mandatory", error
  end
end
