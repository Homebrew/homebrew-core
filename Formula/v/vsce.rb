class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.6.2.tgz"
  sha256 "7fa985bcc864a122e598669558a8c1167d4ba37c1e4f561a64200b4d13ba162d"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "ab70c67b19ba1251580c0ee93a261143febfd579721b2fb9df2e8de807e4f70a"
    sha256                               arm64_sequoia: "979167f8d40eb68ad0091ef5bcec60d243df514d2224029d3c1e7fddb6aad4ad"
    sha256                               arm64_sonoma:  "545fee6c6d65d01c1e766d4e05be633913634c4d765c3ee75778b483466a15bb"
    sha256                               sonoma:        "fb7b142ff7f0d180df91c361a754d1e71a084c148b60069f6d5c3c7a8b3bdfe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142c7ea984a586a18e1c393045c5f548773a1e16e06e3a787c1ad65a35a26877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf62d9a92e051fc32dd369bcdd1b1ec2ebb7231aeb86d6b94fed01c3e34dbbc"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  uses_from_macos "zlib"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end
