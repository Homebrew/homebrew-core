class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.6.0.tgz"
  sha256 "29d6d51254210bc9330120897ca27a084db3e8e7fec2f2cad96d418de53f6ee4"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "f4a024265d736f1f0d815351232fdb461d7918daa707bd31953c50b47f196b79"
    sha256                               arm64_sonoma:  "332bd94089eedee0bbd9480e8108ced651a81f372cacbfb089737d9a1cbf8742"
    sha256                               arm64_ventura: "9abcf683fdba4eed174f2708b6516618254481aa66ed7fbe777db9d5f783bd73"
    sha256                               sonoma:        "ead4ef36d2c06e4a2fa0aa19a08f91540fdcb0d3cc599da0d7b8a8589461535f"
    sha256                               ventura:       "e7c1cd37efc587109b0e39b3d6c790dae435c0b8224f8a6e02d120bad776cbf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8df8d6d3ad56f5027c732d429872a6f53a9e407a434fe4be3d36f2d716a6a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b3b50fc99ad1a9b22f4af14907d960d4ea58405cd40b5b7a5ac5223942536a"
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
    error = shell_output(bin/"vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end
