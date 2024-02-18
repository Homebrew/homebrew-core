class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https://github.com/SolaWing/xcode-build-server"
  url "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "90ea9b8a3e89dfa3a0bf045236c90512f5faac77b76f8039b7937bc6b34d25e0"
  license "MIT"
  head "https://github.com/SolaWing/xcode-build-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acb6a9442ac88d56faef8f0ee71f9f0939125e07157070994f0fd8db077757e5"
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
