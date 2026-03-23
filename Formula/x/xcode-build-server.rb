class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https://github.com/SolaWing/xcode-build-server"
  url "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "92c4bb848af5c8128d4600a93f45e49b89ed953d885c60092459303a5d80e312"
  license "MIT"
  head "https://github.com/SolaWing/xcode-build-server.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61793d886e98bf6a18b02c32944dfd9f98b0186040f3abc5816802840a8dfe91"
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
