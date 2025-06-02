class RobloxTs < Formula
  desc "TypeScript-to-Luau Compiler for Roblox"
  homepage "https://roblox-ts.com/"
  url "https://registry.npmjs.org/roblox-ts/-/roblox-ts-3.0.0.tgz"
  sha256 "94e7ee8db40d0fab605601312838ca8d6d72242e78a8f01e02467f53c4232757"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d98816e699214c5748777941e369d721923661bf31c8ba67e71050aebda82cb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/rbxtsc 2>&1", 1)
    assert_match "Unable to find tsconfig.json", output

    assert_match version.to_s, shell_output("#{bin}/rbxtsc --version")
  end
end
