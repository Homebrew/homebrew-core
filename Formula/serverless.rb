require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://registry.npmjs.org/serverless/-/serverless-1.35.1.tgz"
  sha256 "72eb64e1b1cbae3be11a7cec8e89d35ce1696281c391d02b097b3b15fd42032e"

  bottle do
    cellar :any_skip_relocation
    sha256 "eeb27da27d45a347f5ad7c0a67513193fc5cd35d36cd78de44b30372afabf529" => :mojave
    sha256 "4a5e6b8ea8f4c2f80ad733641ad6e9438df0f34ca0b57348c9a2adc3c9fdda8a" => :high_sierra
    sha256 "114fc037a30d577db6840d517d07fce41e732537827f19a645bfe8810e33b887" => :sierra
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
