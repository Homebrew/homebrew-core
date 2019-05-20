require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.43.0.tar.gz"
  sha256 "b9d48b42c80915ccdaf1a697346725a3cb1d093f21000e4bd4d0ce8f599a40ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "84fb38ebd731605e80c43f37f526366654b62b3114f73cff9428b6e3064e57e6" => :mojave
    sha256 "3627459f7889477ec5b81478ff92d15f18ac45271684eb209718f35bc47c0fb4" => :high_sierra
    sha256 "584f4790965dfc0ad943d1268691fc2c480fefc877cd4e2529b949eacfc12232" => :sierra
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
