class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.6.1.tgz"
  sha256 "2f873b81624321d1870ce8f682519443ef45aea4ecc6d835a633cd7a189dae71"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "4b7f24a99bc0a75e1455738ec376fb12db2721030f9046a783ecd5de9f9607c2"
    sha256                               arm64_sequoia: "323fe732da21a462d50b83846a94e3543631855e99cb29dab3c855ddfe391bb1"
    sha256                               arm64_sonoma:  "02cba514d3de75117c6d5432e64cff9702b46e8c39e49d79694c68ada7c34b1b"
    sha256                               sonoma:        "c75748661752aa82396b32fc0fede874a84b9dd09c3f80da7f1a8f6e25ff53d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ee8297d12733984502552ecfbb659ac284821852fccee6a457599e002441767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d11b1f2f87408994592e114102b06766f09c1fae4e0b4cd6167ff7026c1e8fc"
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
