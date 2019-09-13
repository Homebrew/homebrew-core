require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.52.0.tar.gz"
  sha256 "54e131c7fd3b64702029753077d7f793dbdf17a061111a086f96d8956a780dab"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e202ca59a3045ab5134792f51fcfe40f8d001c017640a59397c53ede38eed06" => :mojave
    sha256 "f5c309744c7484c758644fa456728d4565f4cdc069d9090f1a67e6b509057f16" => :high_sierra
    sha256 "487c44ad691db65d7e75886fbc45ba52d0f41de7001f7e1f48a2d22b5407a772" => :sierra
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
