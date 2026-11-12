class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-4.1.1.tgz"
  sha256 "49c04d44061a9687a9dcb0820c5ee1090e8a9064a9d71ac620dca55eeba2f6a1"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "27e15b224723a6c122549ce89544785e326ae4bfd9ee271708d438113c76c7e9"
    sha256 cellar: :any, arm64_tahoe:       "27e15b224723a6c122549ce89544785e326ae4bfd9ee271708d438113c76c7e9"
    sha256 cellar: :any, arm64_sequoia:     "27e15b224723a6c122549ce89544785e326ae4bfd9ee271708d438113c76c7e9"
    sha256 cellar: :any, arm64_linux:       "cbdcd3223dc76481316c7ba3251de9abe6cfcc6bdcd8b3dd94a2ebc385ffd17b"
    sha256 cellar: :any, x86_64_linux:      "11a7f7637982f59833e4419425eb39bacf00e66b8617d621900f408c278ce152"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
    depends_on "zlib-ng-compat"
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
