require "language/node"

class Ursa < Formula
  desc "A simple, comfortable, general-purpose language"
  homepage "https://ursalang.github.io"
  url "https://registry.npmjs.org/@ursalang/ursa/-/ursa-0.2.14.tgz"
  sha256 "8a1d6be9abc3aa4eb5149510ace0e4429e32a4906df355b88a4385afa45a7d6b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "54", shell_output("#{bin}/ursa eval '6 * 9' --output=-")
  end
end
