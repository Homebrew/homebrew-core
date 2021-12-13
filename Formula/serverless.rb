require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.69.0.tar.gz"
  sha256 "2c6782d3079f4035c2cfbe7d17625db14878e6a08c4f7351b004465ce986a1a4"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "54f96bdbf832116bd3604fa38609307ac2f939700614539176054456ddb1750d"
    sha256                               arm64_big_sur:  "0be7997acd5259c58f6128b61033a3d169d4bd01ca9036823dffcd41ba791870"
    sha256                               monterey:       "a8c53bf42af20a88cbd79c48abb85c88d91327e3f890ef9cb304399c55439ee0"
    sha256                               big_sur:        "77eeab102e96296c2ae561e8bf33dbe73830343bd9f92a40cf5b1635abe14f88"
    sha256                               catalina:       "7bacf73629aff5bade6371dd6af3f4b3bee605710fc1f1af8454fdba3426453f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7774553472a755620ee89449f8169ba211b731d316fc9445719e5416126a4f"
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
