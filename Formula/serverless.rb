require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.64.0.tar.gz"
  sha256 "a87a68d6177a262d86abc1417dcaf6f76ea351fbf7ee41b86c7846d6c7f98454"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab29f09ae3b6e311967eeefb0a2819d1c1713f11712bf628fb5c96fa86295778" => :catalina
    sha256 "051a400f1a39724c656cceaa4b7d459fb2542fbd16eb1c2cb88fe84c859ba130" => :mojave
    sha256 "e1dc554ff0e7ef56d28b9957b776f1ab4944b7500dceec97ebb95f7388a47d9f" => :high_sierra
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
