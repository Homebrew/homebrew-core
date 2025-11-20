class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.7.0.tgz"
  sha256 "70352a3d0f73b0804e6957594da486dc7844a9c1f93b1a74bfd0872e8227bcb7"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "057536a86f5fe9cfb06abc6c8041132d92f3a19e669e31f2f30cd21b69ce090f"
    sha256                               arm64_sequoia: "bc3727d3f6a805d607b6798ab46116f3119888934026a656c5e8e2cbe51eef7a"
    sha256                               arm64_sonoma:  "b0ded65dfc9306b77bde6bf02f9aea5947c232a11d54d9471f507b5356898fcb"
    sha256                               sonoma:        "aefff4eb6dad002a909b14e48912278f813e19fc7119509b6482d0a68aab038e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72ca5ae431fb01bbc9af828510850a782d810ea3d1409ca85f2a75d7a6cb7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d14fd2520994fcd6a62903948da307f4e229c4f4231eabc3b67b3ed408280f4"
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
