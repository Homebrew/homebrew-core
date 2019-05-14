require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.42.3.tar.gz"
  sha256 "eb14c1a33a3fb1a61e6a7ac647e10eec226193a3b1e7b140a4efd4b783d85bb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b4d308424deff33b019671b2bb3d5f2e7287822da26c258ff8e1bc6d8832abc" => :mojave
    sha256 "ada91f7cc9cbebd27ebdd19d77150981a3449cf1a331698493b360c75bd39c00" => :high_sierra
    sha256 "91e4cee04342773e03fa8fc62bd50dfefb69785806fd401abc42f64a7d89cacf" => :sierra
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
