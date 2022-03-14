require "language/node"

class VscodeLangserversExtracted < Formula
  desc "Language servers for HTML, CSS, JavaScript & JSON extracted from VSCode"
  homepage "https://github.com/hrsh7th/vscode-langservers-extracted"
  url "https://github.com/hrsh7th/vscode-langservers-extracted/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "1cb1c8fdea07f70ae3602952ba06b962e6bd60ed50d09d5dce3c5ad3b914030e"
  license "MIT"
  head "https://github.com/hrsh7th/vscode-langservers-extracted.git", branch: "master"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "false"
  end
end
