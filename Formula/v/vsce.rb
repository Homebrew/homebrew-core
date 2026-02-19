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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5dbdbbd13544c659059724ba4b29f8b458e777bb9068afccd635800c0cd4b73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5dbdbbd13544c659059724ba4b29f8b458e777bb9068afccd635800c0cd4b73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5dbdbbd13544c659059724ba4b29f8b458e777bb9068afccd635800c0cd4b73"
    sha256 cellar: :any_skip_relocation, sonoma:        "697e277fb152068f51a02471c748118f6d6e47a74a059b3b1f4f915dc95eb093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6c71ce803227a87a139b666302048a8764083521124526920462df2778506d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51bd0dc9c14019f99dbfe25d4a164ed639347ef5ef346fa4ab574c5d08e871c2"
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
