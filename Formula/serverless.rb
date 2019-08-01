require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.49.0.tar.gz"
  sha256 "a9665799b77ae2417e15ca94efe040bc53901ca4229eeef06989b7ed03994f18"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d1dfbe71b60a8a6c2e111aa903053fe21e4cc5e4a7a49847bc4b43ff9aa57b3" => :mojave
    sha256 "ef9dde725663f643dde3471d3ead9fcde2621a05d01b09bd73cd90b62c8b392c" => :high_sierra
    sha256 "09769a6edfdc95ba303bd6d421f8064284657b95b2159e6c92589b5e21425cf7" => :sierra
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
