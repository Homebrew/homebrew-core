require "language/node"

class ReactNativeCli < Formula
  desc "Tools for creating native apps for Android and iOS"
  homepage "https://facebook.github.io/react-native/"
  url "https://registry.npmjs.org/react-native-cli/-/react-native-cli-2.0.1.tgz"
  sha256 "f1039232c86c29fa0b0c85ad2bfe0ff455c3d3cd9af9d9ddb8e9c560231a8322"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a02c0e2569f9906069d980a6b0d8c0ca3174407a2588c00e8d428ff9c29aa32" => :big_sur
    sha256 "393b87d95115e28c0fc2d56cf5ea0fb9d9f45d6a8d61a33b6805f1bfc24cc565" => :arm64_big_sur
    sha256 "45feb7f98d12b2ee28b6e5f658e070f60a43571d4d8fab679cb513ac957ca7bd" => :catalina
    sha256 "8e6e253c7801cc276f89f2988245866080c1409602c5903dbb2984b1a645746b" => :mojave
    sha256 "387e6f8c0e9f20b4ae2007185d394ff73cc3392085a6a05045b669512780c55e" => :high_sierra
    sha256 "81ef6bdc246a412022d070b5020b567864b177a53fcfeb15c44f7be38e6130ab" => :sierra
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
