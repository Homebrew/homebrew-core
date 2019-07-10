require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.47.0.tar.gz"
  sha256 "c1c143a004039165442c0f5bd03b579c57b6c51d4c7ea45bc831363377957f64"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab4b4d34debfcd5412b77cebb418eb0a4ed4a64082040f8d9b2d6e88c34c031f" => :mojave
    sha256 "ad2aca9ee991c6689980347c9160f45510f3ac064f2383df9a97191992bf6cfd" => :high_sierra
    sha256 "01c079985e48bbfb38aa5a069708db96ff7f7883c530d13b910ce270349785e8" => :sierra
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
