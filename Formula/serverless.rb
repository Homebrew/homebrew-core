require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.41.1.tar.gz"
  sha256 "62b42a7d5e1c71fa79430fba11213737de64c64bf2e3973a3d70185a904d1914"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "3c50cb2f3c416a7b199ff9a619417f57b583a324b03aa43ba0279ce0b7918cf8"
    sha256 big_sur:       "19f458990d24af82aac246b684a05b4621715c74161a272f47d5a3100d21fafb"
    sha256 catalina:      "c35b3f790c721f6e2718cf7d2f3295f94994462ea9c523ccdbc8fffce3ec5084"
    sha256 mojave:        "14a3769813405d208a6965034af12c0129f9808afc21cd9c7b5d3a435f7303c7"
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
