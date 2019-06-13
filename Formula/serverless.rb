require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.45.1.tar.gz"
  sha256 "c57cab8b1a9ba404ee4a3fc75d55a3ea1389da29f0b7b8ca0e4da39a5619c0ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "757dc8fc9975f40063e6c79fcb7c9fc251921c29b1c2f026b8478522c3fc0c7e" => :mojave
    sha256 "4b5fd9c3f3c389d9efa39a54d4b1d4e04fa18fdd291139bb608c26705eb97405" => :high_sierra
    sha256 "4c718592100d5c51e97a8be7498fca50d38800a55aa204b49bd4dc6cdc5a2939" => :sierra
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
