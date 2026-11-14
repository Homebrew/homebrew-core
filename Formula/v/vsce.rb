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
    sha256 cellar: :any, arm64_golden_gate: "b151a1588ed3cf28a301bfe2b8454ddf149a3b91c3663f261ac51f2849f6dcd7"
    sha256 cellar: :any, arm64_tahoe:       "b151a1588ed3cf28a301bfe2b8454ddf149a3b91c3663f261ac51f2849f6dcd7"
    sha256 cellar: :any, arm64_sequoia:     "b151a1588ed3cf28a301bfe2b8454ddf149a3b91c3663f261ac51f2849f6dcd7"
    sha256 cellar: :any, arm64_linux:       "14df9221899b2461fe7a10cde5590801dc61edd106f1c08c601cebe0b588d444"
    sha256 cellar: :any, x86_64_linux:      "89a2c9d5995918664ed00cf8e107ea9f1fedd2b275ce5154d855351bc2585421"
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
