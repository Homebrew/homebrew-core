require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.8.0.tgz"
  sha256 "eca227dce6dba0f2dd32a095df5aeedacba27a7cac14278e32e3b05e9279ca11"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "0027e8e5cb8c412c8d1585b5d3053913c68ca27c060fffafe6b677b4a9ad05d7"
    sha256                               arm64_big_sur:  "83cabca0ad09235e8acde307b6a3af0438cca088eda6a7c0675c36125fec360c"
    sha256                               monterey:       "fcead3c7ed4125817ce3e3eac450f7d61fba1380a7402945876c945e044316d3"
    sha256                               big_sur:        "9e0088850df24f9b4ece0e65f2c151ef2a0942d4ca75a35f4e435e6dfa5b2a4d"
    sha256                               catalina:       "aeb254b3198f42b4d7b8cbe487480dcb1a7fc1c2e03fdcecdb714a99d359287c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "978a1f4e0a0bc438825e4f598b631b30215979d4d59a151cba112bc33499e72d"
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
