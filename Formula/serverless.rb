require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.72.2.tar.gz"
  sha256 "0f88100164d3cb9477e325f626123163562198cec1091f4725217bd6e0918524"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "fc984505ea8e8ef85d7910d489cd6f1bc2807d1b10d8575c0e1a42409593d08c"
    sha256                               arm64_big_sur:  "20a6baf0af84cad3d6461e0f19d801f614634f3b3d5483fba8cb332f49ce6880"
    sha256                               monterey:       "db0cdc28f8327ba703fda0559fa569cac2e80693d145f7525c79f1f320e5302b"
    sha256                               big_sur:        "44a6103f3be2502ba49e50b559688fb031015fa3d04ad48aaf934df69d108aad"
    sha256                               catalina:       "52c4094d847780672f72a68bcbd942d21a3befffcbe5f66c313f7ebd923ea2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbeb9a3fb8a79e0d3890fe4cdb76839bd717c579bd771db8423e2510c98c5ddd"
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
