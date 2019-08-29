require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.51.0.tar.gz"
  sha256 "4d00389ab5cc71b30e73a71dbbbb89365229bc1f0dfdc94f24f6fcd2ee17438c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ab4d5d77cf1aebe0a9ed074b4dadf2d0275ad8c1299396921b08a24795843cf" => :mojave
    sha256 "0421d653bf14d756fc1dc728d368c00b3b77e92248b246d09acea1fc6157cdd4" => :high_sierra
    sha256 "6fb00125d004afb2e00acd9f3746c8aa33e66d386fb8c7592c3ba96567ba2dae" => :sierra
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
