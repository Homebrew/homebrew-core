require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://registry.npmjs.org/serverless/-/serverless-1.39.0.tgz"
  sha256 "cb404813af4acb6531861efc46de2b10a661627bab35da78522e704410d2db5e"

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
