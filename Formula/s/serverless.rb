require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.35.2.tar.gz"
  sha256 "8c70db7c3409efe898dc646985076ed4890189e38a868aca90bbb3fa21876a39"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b11c1ce9db71ab1f6fb6fc276c65780f957825c953c6a73d0690688cac4278"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b11c1ce9db71ab1f6fb6fc276c65780f957825c953c6a73d0690688cac4278"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2b11c1ce9db71ab1f6fb6fc276c65780f957825c953c6a73d0690688cac4278"
    sha256 cellar: :any_skip_relocation, ventura:        "e740523929e6ba1e97548ead5119f15c3965d62afacc320f7dd39f83681ac405"
    sha256 cellar: :any_skip_relocation, monterey:       "e740523929e6ba1e97548ead5119f15c3965d62afacc320f7dd39f83681ac405"
    sha256 cellar: :any_skip_relocation, big_sur:        "e740523929e6ba1e97548ead5119f15c3965d62afacc320f7dd39f83681ac405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d88c95bf016d8aa131dcb1477b084fcbfc1ec6362ef7e2390688eb96ffcebc6"
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

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/serverless/node_modules/fsevents/fsevents.node"
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
