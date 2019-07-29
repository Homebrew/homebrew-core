require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.48.3.tar.gz"
  sha256 "c7c4917331186b9b1a19b4db1879e14013b90317540dbf8ebddf4eeab976c5ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "d40f9e082166c33a14bd88f28c540f64c74c37ec9eebc8df847fe62a8b0e94b9" => :mojave
    sha256 "d4f3d897e8ec168cbbc95c0a961dd373a1da4ce3b581a5e37655faee4c33b1ef" => :high_sierra
    sha256 "aba3714ab467f790a149dcee0f18ad5393160d4f1935ee401e936a15d5d6d602" => :sierra
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
