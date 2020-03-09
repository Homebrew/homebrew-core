require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.66.0.tar.gz"
  sha256 "ffbb7c4c780d5d8f688a55c1d0003516efaadc885bd62a0ef08ec47d0afc1a85"

  bottle do
    cellar :any_skip_relocation
    sha256 "a905ea1a17b66738faf8f5d011a58b487e77a5e472d530ce7f866f8d319353a0" => :catalina
    sha256 "4824d163a971c48ad92499cc6dd63ab442294e16614c0214f9388f0989017519" => :mojave
    sha256 "8a3145f4411468ca0364a94937f69fd9ffcace9a26b05f8fa0f40536171cf1a2" => :high_sierra
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
