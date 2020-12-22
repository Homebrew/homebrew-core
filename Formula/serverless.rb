require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.16.1.tar.gz"
  sha256 "b3ca46e792c2fcef24e94583b70f299c4ba67b8770e5ded7d9b28b90f0f16589"
  license "MIT"

  bottle do
    sha256 "9e18d77d6a4c4caec88e7d653bd2db3cb507190306a5bce749cc1bff0688bdbb" => :big_sur
    sha256 "8c042949db8320af57e129dc00820461e7e0de67c0fe2330574957922234d72b" => :arm64_big_sur
    sha256 "3adbd8f8fa8259ffa734f59779b3b3223c5c72f313326206b19f80eafedc182f" => :catalina
    sha256 "4b58ca7e8d18a2b71bf9788e4d89215383e6f777815acfbe377b4806cefe805c" => :mojave
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
