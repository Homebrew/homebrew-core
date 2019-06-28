require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.46.1.tar.gz"
  sha256 "308191f8819fc65e42a8543f0f273014d3a62f2d4645d1621e418b97b698ade7"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e35b32ba405463110931de64d8b500d0aa180fc167cd51acd86f55f80b970c6" => :mojave
    sha256 "99db84f985aa7df30282f68b72aa87ae88dbf83f41d9d544ef6a346049bc0cdf" => :high_sierra
    sha256 "b0b3e708049ade00ffced9a822d06ab60a45bb2a9d8689eda3a37a819029ff87" => :sierra
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
