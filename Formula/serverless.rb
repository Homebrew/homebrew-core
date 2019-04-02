require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.40.0.tar.gz"
  sha256 "addcea494ce7b297fe026348fd9eaed0aa4f65f207f813e4e06696266d7703e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd4daa1088825a521c5afaf1547b28ad0106bc1e6af4cd7062da02a9b7c8e5ba" => :mojave
    sha256 "6910feb3477538640bc7d33eb240f800542d7b9f7f3c21ae4b584630ecae0122" => :high_sierra
    sha256 "1906432872021ed23207eb341ca00479d06f0fda01750a5b490e2932b088f1f5" => :sierra
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
