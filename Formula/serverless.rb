require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.42.0.tar.gz"
  sha256 "aff0dcd65f7bcb0b18a13d703eaba6242ba5714c483dd9ca097022297dacbc37"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "017f6903b1abff547c7d7b947b75180ad0fd7baaf1d4c2fbcdc0fef80723b09f"
    sha256 big_sur:       "b3ed750b181a97c040d359ae7ceb6fcf3c47c5544058a714a372f6d68828069b"
    sha256 catalina:      "91d443442ec95bedb2362d4b43f037b83130c3d175bde359a38d31ccb260fbe7"
    sha256 mojave:        "f6fec0268987a934877572b779657de4a1a0f8738fb05be7bb0322b5922047a6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
