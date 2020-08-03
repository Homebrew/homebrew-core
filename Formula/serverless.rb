require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.78.0.tar.gz"
  sha256 "4bbb6d0b7d73fe3c8dd0755906f42dd2ff745049d69fecc1bb4d9719ef06ccd0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "eeff05c4fd202ea539227228af957f59781c0db5799067598a3ee9604947e308" => :catalina
    sha256 "fd3bf8c977d965f29d9288fba5cf010f5432d6c75769ccf00932196b53ae0bdc" => :mojave
    sha256 "4584e87daab7c65c043138c659d740c058ed7adf307bb23471042323a9c068ac" => :high_sierra
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
