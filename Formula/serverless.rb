require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.43.0.tar.gz"
  sha256 "b9d48b42c80915ccdaf1a697346725a3cb1d093f21000e4bd4d0ce8f599a40ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "b28cf32a0dcf157735f4acc1c6e6fd63fe782282ac93ee0a5421d3f355a3d15a" => :mojave
    sha256 "99631bcae1b5777d87e723f84d939f593b0cdc146eb1955546bbf3c79ca6d979" => :high_sierra
    sha256 "68b2c9f5335fb9440fd3e0a2d250481d618fa326a3652ffc35324836530df617" => :sierra
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
