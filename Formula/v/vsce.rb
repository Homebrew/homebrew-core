class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.3.2.tgz"
  sha256 "7951916bcc8532023decdb5eccd2c88944b3191acbe8fd6c63dc7c371a14f2eb"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "f2e6ec67090ef3874f53a5ad49cab86e2d0aa66473098f598de6cbe8eba18df3"
    sha256                               arm64_sonoma:  "ceb4234b0f8d030213f0bb8b4b2abf689079d208ae81f53e21b66d6567ad8587"
    sha256                               arm64_ventura: "d2b9df14ffdb5b52fba7191f9f17cd27a0a62a4ebcfbf21a542ab4b9b1c09292"
    sha256                               sonoma:        "87d9337c3e78fc86aaf9547993903c8ee7a495fad8228af0e9f987912cd4d81c"
    sha256                               ventura:       "2361d50b3d28721ff40b33adab9a71eaf06893fd8afc0768e2e9898ee659490a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6f891607b2eb325b6a87cd7ef8d775511e754df5f1802b7bc1c0f983bc05196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d030011272008cb81d162b28a2a998c83b9d7ef75c77df903b7ba3d8bfad9efc"
  end

  depends_on "node"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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
