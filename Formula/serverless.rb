require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.77.1.tar.gz"
  sha256 "77b4ae0635e8b492870d6f4c170b7f39e5f7dcc9c845fca81ef3953b66a5ec19"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3d8e524ba82b2a3eafd2cc766344b51a7f2f06e71c23979558b64d6953bd6a2" => :catalina
    sha256 "d8eb889456258d216dfcd55369631cd42bdf2b4d4ee97f38b8fdd5352e3226b2" => :mojave
    sha256 "2abcd809630a533fbcb86446836d095f7424e0a155e88c4222947ae064edf9ed" => :high_sierra
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
