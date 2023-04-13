require "language/node"

class Terminalizer < Formula
  desc "Record your terminal and generate animated gif images or share a web player"
  homepage "https://www.terminalizer.com/"
  url "https://registry.npmjs.org/terminalizer/-/terminalizer-0.9.0.tgz"
  sha256 "512ec9dc30a5d0a5471223352fb14094222e684f72c5a9c23c196a4d90206fb0"
  license "MIT"
  head "https://github.com/faressoft/terminalizer.git", branch: "master"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"terminalizer", "config"
    assert_predicate testpath/"config.yml", :exist?
  end
end
