require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.14.0.tgz"
  sha256 "160b2e5e3a381ec249d13615e104ceadb52972a43eff1d0bdb177f488025d96c"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "acd2af0b9a1893ec75d6253ee63c16f01de621102db1cd59fa8a82043a38470d"
    sha256                               arm64_monterey: "7672b5b42555b9500014fbe0519d019909f05f7dccbdbc98eced30a7b82e65cc"
    sha256                               arm64_big_sur:  "b6346460c8f5dabbee25108816a01bd322ab28c7bf05715c8a2f706e4d6e9c73"
    sha256                               ventura:        "3ac06e43e71cdddbed3c9ff51d34681909424bc13c5299188051726930f7ea05"
    sha256                               monterey:       "c88b50cb8939e8ed22a1eb9c1fb805b633228e5d9af44d1e80c3899c833f95e4"
    sha256                               big_sur:        "6015efbc69fa2ba06c6187d9139599d4391041d2398e02a4ce3c07b6298f2357"
    sha256                               catalina:       "7ac92b45d332653e98ea6a7f2a98e2233d5f75699cf4a0a243dfd8a1508faade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b01d508db4acd83a8ed5f5e0991ef8dd4a1069817a070797118b4255f7715a5"
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
