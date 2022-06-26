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
    sha256                               arm64_monterey: "6d5ca7333deff98669ea59599df01510d3ea607aa29e4a6fbf24a686ca635298"
    sha256                               arm64_big_sur:  "7da944cf9e907266257002a983bc78af7e6f29937941f3d0ac7c9b3d6c505f7c"
    sha256                               monterey:       "57bf61ca73749620f761ede9c58bf378fe13d4bdde5226ba85f350343bdc78e0"
    sha256                               big_sur:        "ba88b0df0fec75a6fb35b8d0db10abefd2f0a4cba7b5e761d5f8633346b6335a"
    sha256                               catalina:       "ed76bc0d93997fdb066dbf7fb127af47ae5cc4c74bb8838a0d357b4000000ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a765551a22a82367f8b1b51258be4bd932221e4f82c2d97297bb55aa93503e6"
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
