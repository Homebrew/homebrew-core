require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.2.1.tar.gz"
  sha256 "cc52ca47f8b6b836991e7c44efe6c3cabaf6acd0e7ddece57cbb0109367fbe36"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "113ae020c78eca158334cdbbf9a1503a4038df58335dd3c84ce521e2296db0e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "113ae020c78eca158334cdbbf9a1503a4038df58335dd3c84ce521e2296db0e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a34f020a33c387c63d8bbc125ce1d7e2cbf5b21f2ba324121baa286708df89"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2a34f020a33c387c63d8bbc125ce1d7e2cbf5b21f2ba324121baa286708df89"
    sha256 cellar: :any_skip_relocation, catalina:       "e2a34f020a33c387c63d8bbc125ce1d7e2cbf5b21f2ba324121baa286708df89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8445c1e762df8665d97e9e5920d7b7ee3620166429b4462bbd6f663c33ef3fc2"
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
