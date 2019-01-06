require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://registry.npmjs.org/serverless/-/serverless-1.35.1.tgz"
  sha256 "72eb64e1b1cbae3be11a7cec8e89d35ce1696281c391d02b097b3b15fd42032e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d708d77b819afb2896c2cb5a59628e96df5b921356963cf640460bc0451dacc3" => :mojave
    sha256 "a3456d38a0cc201a1ca7668730c2134b1b52082475bc2ebc46cd14517668ef4f" => :high_sierra
    sha256 "700b5ba723cc9b5815a70424f5d3748ea6496ce09d5dca7b72c3a2bd92006a04" => :sierra
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
