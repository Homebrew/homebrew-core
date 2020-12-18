require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.16.0.tar.gz"
  sha256 "d48bdb06d72f9673fa367a9920dd0f694480cf2e52d09ee0cbedaca985efdda3"
  license "MIT"

  bottle do
    sha256 "bb45ef565245efc4031049647407887209f88c38c8d7efc32781cd54063c1a8e" => :big_sur
    sha256 "47d92cb8ffa65023dd0c3f40c992dd11e808de4e1c02df3f5889aff6b0043763" => :catalina
    sha256 "f6699e54aed7db10e89b8e740a12ac71798e3eab59f4a76a07ada34cb8d48927" => :mojave
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
