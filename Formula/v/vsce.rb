class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.7.1.tgz"
  sha256 "aebab0210edcc5ddc5d3c90f420ba283dd6552968448714640fb78c2a0c4ce35"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "3b1aa5fe7412b69b47c2ac683bd19d3d1a4536f8d5a2e1d0d453575be0114850"
    sha256                               arm64_sequoia: "816304e05516bcbca943945cdc0cf0d6aafc60ce66d0957f8ac845d7602b08d0"
    sha256                               arm64_sonoma:  "bc79af02a8a6790a9abcde0cb8444ebb3ad8949c331f5ab2f08f1ff8a4295ecf"
    sha256                               sonoma:        "3773a67cb4b9175f7616e78b5ce9d3141e27954b1dfb4ba33bf64074d1357a04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b7643a95eb08f987e4f5ab777a2175a47d4fb6a0f167f402eea8908f933bde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0c7492e84e88ffeeb940d2260c53d04bc5278f0e1b9125b8732fb5698b4d7b"
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
