class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://registry.npmjs.org/spago/-/spago-1.0.5.tgz"
  sha256 "8d91fafa73a6ed23b7ab0176f0b5a20416b1ce083848d65b85d2b2650922af36"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d61a801277873d41b6b3c797903feea5f86bcb0d8f97f38864343fe46dba84c1"
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
