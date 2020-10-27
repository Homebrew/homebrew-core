require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.8.0.tar.gz"
  sha256 "5b12bd2bca7ae4676f74654f7831e91ef0b9fa98dd774decc14fd634e0f93dd9"
  license "MIT"

  bottle do
    sha256 "68928caccf062014d1b157703539f6ca55b37e50886c8e27d96431967ca157b4" => :catalina
    sha256 "5376c3896ecc30c5b69479e62083266186121aa5f9f62028cedbe99dc793045a" => :mojave
    sha256 "8ef03b628bbd11d2129f834f418baf0a775b1e75324dc60d43161d978fb1a5c6" => :high_sierra
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
