require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.71.3.tar.gz"
  sha256 "a95c0b4fa1a52792b05402f1bcfc6440ebf0a394aa5c81895a45e4130b7241b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a297b1614935a75600130211c86312bd480e6e87be404a5d7b54f9f4f7acbf1f" => :catalina
    sha256 "cc463a5acac0d82f9195a579594bbcb0a303bae0ec41d606cf3d0c9fb1f0e261" => :mojave
    sha256 "594e751340e2ac15d33e914e0faed11e2eb948d13e537776f223e2983010287c" => :high_sierra
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
