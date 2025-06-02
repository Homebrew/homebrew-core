class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.4.2.tgz"
  sha256 "50a4d47a38c7bf8b04332dc2c9c30e8772b44d8e430fb50fd3911706320e043a"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "b24a646ffe3394a8d6645ae8a4f98b9473966810c1f00ed24575e31d2fe23a67"
    sha256                               arm64_sonoma:  "7e2cc6ff5907578406123f9b21d77008474952f4310179d67730ae7c8928e786"
    sha256                               arm64_ventura: "c6725b4473fc154d7946157565ed0a6d5f79bbfa726d7e549ba5432488e2d680"
    sha256                               sonoma:        "a12a0c57153008e6b0865f5d6bd62d3b7da4df47934b52267eec3cae7f193e69"
    sha256                               ventura:       "9386ee42a9c61fe5f0997080ce4e31a14549e15bcc74b4c255985f06a86fe4b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e63bb13eb7b7947cb9060f9ab9fe2d8b23e0d1f6b1ddfad72f5eb35bdb6cf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf936e711330acf51518ef9fe322b5aeade391b3790d8ee269f48e8b9243981a"
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
