require "language/node"

class Terminalizer < Formula
  desc "Record your terminal and generate animated gif images or share a web player"
  homepage "https://terminalizer.com/"
  url "https://registry.npmjs.org/terminalizer/-/terminalizer-0.7.2.tgz"
  sha256 "25ad22a9aa79e56192c3e0ede25fed40b5b9933ee07da4ee264357c1f6c85938"
  license "MIT"
  head "https://github.com/faressoft/terminalizer.git"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/terminalizer --version")
    assert_match "0.7.2", output.strip

    output = shell_output("#{bin}/terminalizer config")
    assert_match "config.yml", output.strip
    assert_predicate testpath/"config.yml", :exist?
  end
end
