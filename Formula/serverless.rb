require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.0.1.tar.gz"
  sha256 "1f823893087f2b6dd1465dd933ad112adff8ed42e48c1fbd90b4b77ab81be622"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eff25b660638ae4d82a7c760e2a090eb660c8d6b42bfbd90f0d63b78dea3d72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eff25b660638ae4d82a7c760e2a090eb660c8d6b42bfbd90f0d63b78dea3d72"
    sha256 cellar: :any_skip_relocation, monterey:       "f66304171d5a1ab7d2d0559f79c237850fce256467c2528af35ed48d10be7cee"
    sha256 cellar: :any_skip_relocation, big_sur:        "f66304171d5a1ab7d2d0559f79c237850fce256467c2528af35ed48d10be7cee"
    sha256 cellar: :any_skip_relocation, catalina:       "f66304171d5a1ab7d2d0559f79c237850fce256467c2528af35ed48d10be7cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493f213b9086d693253baf2023eeb9a53bffe3315e6d1ac641835974682f597c"
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
