require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.18.0.tar.gz"
  sha256 "f3ecf826036c26b977e9b4b385004da15730c28eda3661c8f11c15e2f3c5e683"
  license "MIT"

  bottle do
    sha256 "e1f489ea6463e84bcb531a6c384249500329acca615850b056c2049052c3cf0e" => :big_sur
    sha256 "47ecf0688413be3d88632ce5ddcada69287a1834e7fe7138f475776e9e109aab" => :arm64_big_sur
    sha256 "f5d9e5adfa6fd99a05dd6d5acb230f395eaf2c539ee9f1d18f03bca4738edea1" => :catalina
    sha256 "6652cb27713902442f413d85c77ec5bf98e8dba6374dcf55f4249843c49f840d" => :mojave
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
