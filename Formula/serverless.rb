require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.1.1.tar.gz"
  sha256 "4043faf610d6c6567f6ca822d294d1bb19e514721f4446a8b6d222901d6857da"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cdf5cfa6daadbad0171591aee9ed7d87815140b07f9123c149634e338f5141f" => :catalina
    sha256 "31fd459cbf628c82778cbc3a9496114f8a1d3a904dcc3d0efcdd4f8d8ef3b94e" => :mojave
    sha256 "a5e074f40b1269f5d8d186b09ab50d4c57eb9ae217d110b47605e9940aa46d83" => :high_sierra
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

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
