require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.69.0.tar.gz"
  sha256 "f2e2c254f3644f41a3a2ca8893733b1624c8bacbf8bcdf2b214d956d7c736152"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f29611daa9466ae6ccee6f431e0cb6415370c1a8969e2fde67c42a9311bfac2" => :catalina
    sha256 "d957ef48cdaf38912f35e0eb32eb273d4ba38d38a787c48c3d889980ecab510d" => :mojave
    sha256 "52c9ac009e90182b608815f7df75bb190a15538edb906c01dba22b5d7e772521" => :high_sierra
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
