require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.12.0.tar.gz"
  sha256 "135170962f8b1ae9129e36e0a57d09509105846f0b193dd0d29a33d43a0234b5"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f36816b8d70b7735d5ee90926fb4656e77046a470e220d8caccf42677a7c347"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f36816b8d70b7735d5ee90926fb4656e77046a470e220d8caccf42677a7c347"
    sha256 cellar: :any_skip_relocation, monterey:       "1985a70828bc677dc3090621d3bb983c9da548c8864e891c638ac7f261249fb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1985a70828bc677dc3090621d3bb983c9da548c8864e891c638ac7f261249fb1"
    sha256 cellar: :any_skip_relocation, catalina:       "1985a70828bc677dc3090621d3bb983c9da548c8864e891c638ac7f261249fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13917b9fc68205bc802e9d3706b2f7adc2f32f9626f240db23ae6e382915fa13"
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
