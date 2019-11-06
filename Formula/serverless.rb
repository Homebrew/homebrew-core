require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.56.1.tar.gz"
  sha256 "8c010bf5c48dad6cdeba42030714749a45d0d82a73f3341bdfc2893f5f296c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b638fd713397e8b9adde3411a2d0247724f548e506b6f1ca666ab6c74dc34a8a" => :catalina
    sha256 "9686da917ecb9b51e883f3a6bb46c25038c5f28d7da817bb2ad4c9579cc2e759" => :mojave
    sha256 "10532b800846be2e50714db7c3e45e190835f5b79de94076770305b70a111684" => :high_sierra
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

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
