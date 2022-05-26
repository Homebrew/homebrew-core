require "language/node"

class Xlate < Formula
  desc "Translate your XCode project into multiple target languages with one command!"
  homepage "https://xlate.dev/"
  url "https://registry.npmjs.org/xlate/-/xlate-0.1.1.tgz"
  sha256 "e7416477cd0821670c7f15acfe050a884b9e94ed9d2f24cba8b1cab182f1336f"
  license "MIT"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/xlate --version")
  end
end
