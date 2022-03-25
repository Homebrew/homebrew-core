require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.9.0.tar.gz"
  sha256 "18a51376562487afa85fd34bd9327726a21436ec3fc5e855195ec440448b9d43"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37c8e08dab19c65d1949265478c1862e6964b5454ce9c65f489f0619ac55fa1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a2b66fa3c35bbe322167ca8893f3b1425790542504e881752b4b26b1e6e47e1"
    sha256 cellar: :any_skip_relocation, monterey:       "0967001c422ecf496745fd2b3ef7bdd65d1e4d0edeefb2c2578f184111a4fca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0967001c422ecf496745fd2b3ef7bdd65d1e4d0edeefb2c2578f184111a4fca8"
    sha256 cellar: :any_skip_relocation, catalina:       "0967001c422ecf496745fd2b3ef7bdd65d1e4d0edeefb2c2578f184111a4fca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192a69764cf2555c7f907b734c2127fd94de440908d236d43f346915ca9c4f5b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
