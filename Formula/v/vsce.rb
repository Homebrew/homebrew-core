class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-4.0.0.tgz"
  sha256 "de32bbd17a76ff3471a36e0feff4e07510b3783065b77b1c094685b0accb1d7f"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3014eac759d264b1fc34e412e6718076a1ce4dac906025ab38fb16c5c2a28e85"
    sha256 cellar: :any, arm64_tahoe:       "3014eac759d264b1fc34e412e6718076a1ce4dac906025ab38fb16c5c2a28e85"
    sha256 cellar: :any, arm64_sequoia:     "3014eac759d264b1fc34e412e6718076a1ce4dac906025ab38fb16c5c2a28e85"
    sha256 cellar: :any, arm64_linux:       "5d995d17d7aafbaa3da0938fc40eda6c40ddb7827f661921f2a7668cdef1d638"
    sha256 cellar: :any, x86_64_linux:      "01756330f11062c042c9be0fbf0860d4590591b9ad5921d0565288d122c1bdb8"
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
