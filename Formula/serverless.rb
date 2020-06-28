require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.74.1.tar.gz"
  sha256 "823a5c163c74fc8b4953a44110e9b2591f64d53cb56b69470db9e132811dd477"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb0878eb909b0189fa425733a1463d7f20f114b43f852d4185ff5d5d4fccd158" => :catalina
    sha256 "c07b0341c92b0071d9c5305c81853cf34b77e137376565e2cadc98e109be2851" => :mojave
    sha256 "d7635bfe09811d4df6c02241ee86be366e627c11172df5edd62c8d161c4579ae" => :high_sierra
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
