require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.41.1.tar.gz"
  sha256 "c65fe64fb84dfc63897a748de1d25ca7bfb60bc347c67c254ad2d60b70eccc4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9942c905fe47af3d64d735cfdbf978bbf8e3e0b6ecde55af3f10acb7abea7a4" => :mojave
    sha256 "8c54e3c6f5d04125c1c46379bfd7b23b2f5edd92a1ef718a416f4a937a06953e" => :high_sierra
    sha256 "87b54a3e19abd0c2b4d7bdab738234a28962725ab6ab552a9f3c9b4b7b7fc68c" => :sierra
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
