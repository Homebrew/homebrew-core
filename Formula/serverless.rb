require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.71.1.tar.gz"
  sha256 "58acb1620469aa0a93760c9295c4028b599cd4fc57ae3e4a88866fc81ded3ff6"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eeca0b36a6b606fd3943344f3a8a8b4a80b32516982da51cb7d8f1a0e27307c" => :catalina
    sha256 "0c649dc777883ce257a848a375355bb1629853d15d9a76cd51b178496d865a8d" => :mojave
    sha256 "f809488ac48677b802d91c6a0250bc2f878477366b08846d080bc9733de031d0" => :high_sierra
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

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
