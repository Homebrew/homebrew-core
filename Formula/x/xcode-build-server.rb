class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https://github.com/SolaWing/xcode-build-server"
  url "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fa2e6d30ef24f5b688ca20b409cb0594f16b117934cbdc72faa62cb49ac413bf"
  license "MIT"
  head "https://github.com/SolaWing/xcode-build-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f5db53f5f0fc9ea907e34bcc79f678ed6bfd368e3d5a6e73d48d4b0c992d388"
  end

  depends_on "gzip"
  depends_on :macos
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]

    rewrite_shebang detected_python_shebang, libexec/"xcode-build-server"
    bin.install_symlink libexec/"xcode-build-server"
  end

  test do
    system "#{bin}/xcode-build-server", "--help"
  end
end
