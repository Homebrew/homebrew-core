require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.10.0.tar.gz"
  sha256 "3181f7e5da9bd28635c3b99b0bfe6f8de848d47e08596370edcffdc0fa6388e2"
  license "MIT"

  bottle do
    sha256 "d0a2812612ff86e3eb505c255d45edf391b238dd0575f294443e26976cf0ba67" => :catalina
    sha256 "ec445a8f8c4fa800f099ae8b69e64bae806bf9c39954e42f9db2a697033dc124" => :mojave
    sha256 "f1f5621d8becf57cff102a0d7cf5ca995adf77f93d209cd02684fa9687d31799" => :high_sierra
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
