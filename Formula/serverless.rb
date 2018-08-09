require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://registry.npmjs.org/serverless/-/serverless-1.29.2.tgz"
  sha256 "149bd01446ea433bc2e692bf42aa8149b15c9a11db1c8c80597836d1558f6b2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9bdf2129f9b3b2a22b470fb0b0b1cc1672440606c7dc2d43da5fe446ac8b046" => :high_sierra
    sha256 "e07622638e8804de0c081b96fb25ab78a5780c807043676b84ffcaf70d5661db" => :sierra
    sha256 "a03cca3f81c5366cc708c9e1f0c2f9e4b64a7d2ac62e88a3df40e0ae2aee9923" => :el_capitan
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
