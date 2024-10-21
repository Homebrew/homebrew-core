class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https://github.com/SolaWing/xcode-build-server"
  url "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fa2e6d30ef24f5b688ca20b409cb0594f16b117934cbdc72faa62cb49ac413bf"
  license "MIT"
  head "https://github.com/SolaWing/xcode-build-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fccb7dc23c0cffc541fceaf0583e7d305e35551a340315cd067a7cb0723a07d3"
  end

  depends_on "gzip"
  depends_on :macos

  uses_from_macos "python"

  def install
    libexec.install Dir["*"]

    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"xcode-build-server"
    bin.install_symlink libexec/"xcode-build-server"
  end

  test do
    system bin/"xcode-build-server", "--help"
  end
end
