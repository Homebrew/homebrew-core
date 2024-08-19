class ReactNativeCli < Formula
  desc "Tools for creating native apps for Android and iOS"
  homepage "https://facebook.github.io/react-native/"
  url "https://registry.npmjs.org/react-native-cli/-/react-native-cli-2.0.1.tgz"
  sha256 "f1039232c86c29fa0b0c85ad2bfe0ff455c3d3cd9af9d9ddb8e9c560231a8322"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "286f38336638ab6b72ee871aa7b2d71e691601b4c41e86af258d393efc6dffd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286f38336638ab6b72ee871aa7b2d71e691601b4c41e86af258d393efc6dffd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "286f38336638ab6b72ee871aa7b2d71e691601b4c41e86af258d393efc6dffd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "286f38336638ab6b72ee871aa7b2d71e691601b4c41e86af258d393efc6dffd8"
    sha256 cellar: :any_skip_relocation, ventura:        "286f38336638ab6b72ee871aa7b2d71e691601b4c41e86af258d393efc6dffd8"
    sha256 cellar: :any_skip_relocation, monterey:       "286f38336638ab6b72ee871aa7b2d71e691601b4c41e86af258d393efc6dffd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59fc8b8c6188532bd4d646071108dc246a4ed7ebd9914040bd093988143c73c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/react-native init test --version=react-native@0.59.x")
    assert_match "Run instructions for Android", output
  end
end
