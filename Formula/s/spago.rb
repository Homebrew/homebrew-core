class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://registry.npmjs.org/spago/-/spago-1.0.3.tgz"
  sha256 "c19564dfd1653baf6d458e3727c8849d4ab4b0ab321bd3fa4608058f3c1e9256"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03cb53733447b6a3f5b1ba1ed1e52944a18ad74c93127f8b215f8f4a3e6b46fe"
  end

  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"spago", "init"
    assert_path_exists testpath/"spago.yaml"
    assert_path_exists testpath/"src/Main.purs"
    system bin/"spago", "build"
    assert_path_exists testpath/"output/Main/index.js"
  end
end
