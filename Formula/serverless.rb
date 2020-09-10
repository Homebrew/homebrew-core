require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.0.0.tar.gz"
  sha256 "cae0447b5813f8a155dc69cc109a2a5ac80c255549e3f70ecd676d7b50a1d643"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "117ff433a363a00709886144a16ae0f0931ed69dda63523363e82d4339aa4281" => :catalina
    sha256 "2c6a779bfd34a6fe89b440c76041283c13a2baaa4b5f9d7cba049a6f9cf0e421" => :mojave
    sha256 "f7b1cd7ebb934655b37d0553093c5a0536d33a642f3eb42e5f2535d78f0b9946" => :high_sierra
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
