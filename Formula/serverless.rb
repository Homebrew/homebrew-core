require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.2.tar.gz"
  sha256 "2e94dc71e3b6970338be4012d2fa86b541b9a4ce535766a935390f96f5307a27"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e64b8ee470f39e6483783c00cd663fc4435590b4a1e0686ba5cabfb022ac93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72e64b8ee470f39e6483783c00cd663fc4435590b4a1e0686ba5cabfb022ac93"
    sha256 cellar: :any_skip_relocation, monterey:       "154057bfff5a7660ed44dd50cfe0b6c89a850f71e772641490d5ec0d132fb155"
    sha256 cellar: :any_skip_relocation, big_sur:        "154057bfff5a7660ed44dd50cfe0b6c89a850f71e772641490d5ec0d132fb155"
    sha256 cellar: :any_skip_relocation, catalina:       "154057bfff5a7660ed44dd50cfe0b6c89a850f71e772641490d5ec0d132fb155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3700f5feb68ee1043c3112fb6c942c1a72bbb9a4c9967bf724a6270233a458a4"
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
