require "language/node"

class ReactNativeCli < Formula
  desc "Tools for creating native apps for Android and iOS"
  homepage "https://facebook.github.io/react-native/"
  url "https://registry.npmjs.org/react-native-cli/-/react-native-cli-2.0.1.tgz"
  sha256 "f1039232c86c29fa0b0c85ad2bfe0ff455c3d3cd9af9d9ddb8e9c560231a8322"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bd0fcb144d7edefcc27c70aeb12e143c1f5fd5a2d63a8cf22dab475885db0ab6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/react-native init test --version=react-native@0.59.x")
    assert_match "Run instructions for Android", output
  end
end
