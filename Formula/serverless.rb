require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.11.0.tar.gz"
  sha256 "979ee7b2be1fd1082be62a3dea0fcc70b44b5aa5ed223d8bf7c8bdb555d15117"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab796fcf547b3f5cbae405361a9a3a1a2fbc073d352902871faf1fd5b65561a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ab796fcf547b3f5cbae405361a9a3a1a2fbc073d352902871faf1fd5b65561a"
    sha256 cellar: :any_skip_relocation, monterey:       "568d5e20d6f3bd87d6793e7fc9be7850dbe24f5d880802b835b69cb274944c65"
    sha256 cellar: :any_skip_relocation, big_sur:        "568d5e20d6f3bd87d6793e7fc9be7850dbe24f5d880802b835b69cb274944c65"
    sha256 cellar: :any_skip_relocation, catalina:       "568d5e20d6f3bd87d6793e7fc9be7850dbe24f5d880802b835b69cb274944c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ffc44fb884d2ecb2780f3a46f05e8ff222e6aec0fc4114f4ff7877e1a84fd3"
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
