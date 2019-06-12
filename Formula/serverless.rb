require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.45.0.tar.gz"
  sha256 "dc09385bc9e3ed24766c255b4fcf06ee94b6d1e3cb0d9e22b77e7924fdd946c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a43814d6da97f1801a824bc3c5bc61be1201ffa76536cea6d310de22d5969ec3" => :mojave
    sha256 "5b747810c246ae9e8924ec932ecc58c00a919247b7ce8c4cd459eb84c2a05804" => :high_sierra
    sha256 "3f5328ecc8bf959eaf4ba1d25fea74e437d095614946bf49cf8395bb41b81332" => :sierra
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
