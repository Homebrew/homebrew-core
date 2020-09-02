require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.81.0.tar.gz"
  sha256 "6ae06afb0bb6fe472ec741b4dc8b034d57e4eee68f77f46b289cc066c3c42871"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a6ca2767c3dc1819d7382b3920b6b1844334c71f973539706d65141c04a2cfc" => :catalina
    sha256 "3f2a0741748d31cddb887473095ad89a317f867d98fe0c73fd2568e54ee5c178" => :mojave
    sha256 "bd1fefe8201c5c37351be454d31a33ecb2356c8ad9821c9ed21c60486972d945" => :high_sierra
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
