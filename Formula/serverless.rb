require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.59.3.tar.gz"
  sha256 "797c9fc837aff558682f890313833e2191148ebd5da1ba0ec3004c79bb0b7e4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b46d8ab058ef555d74f577aeba75d7f720275eb1d66653a178aa206a0f31eff" => :catalina
    sha256 "4ea4623092b00917b237061f6df1a397cc6a41091aab40d41b52c7134e31e248" => :mojave
    sha256 "177d6c18fef0164e94f1f871b10827569058d900d5c2662f2ce7b1fdf82ef2c2" => :high_sierra
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
