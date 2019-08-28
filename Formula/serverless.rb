require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.51.0.tar.gz"
  sha256 "4d00389ab5cc71b30e73a71dbbbb89365229bc1f0dfdc94f24f6fcd2ee17438c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b127da5ec716195145af1dccad78bd7ce159e7fd9e753a739711fec3c62f0d44" => :mojave
    sha256 "4149e818bb6e43b251b2932f4508173093d0b3c621cf840f1a441619e52ba434" => :high_sierra
    sha256 "530b948770c9294737e48bb995765646157cf3d2ae4e2ad521a007b645073eed" => :sierra
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
