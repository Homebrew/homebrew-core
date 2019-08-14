require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.50.0.tar.gz"
  sha256 "6cfb0cb9e61f8c7f6b8fcab9ac8e94f9cac82f6438fc05f1b978b5b25f8af75c"

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
