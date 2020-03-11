require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.26.tgz"
  sha256 "1ddb89594ae44b481289e1e0a50c216cf403a1f673bb992a53c1031cd3777cc3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a679412ef1121053ddbfbe885fb8a60044e6d3c633b0012e6d7315ce7200f47" => :catalina
    sha256 "d883f624c3261bd50fcd703dd7029260c8039d2321326358e460d6e212968366" => :mojave
    sha256 "635edcb7cc0015bcab92be515488e835ac3efd624c40b566c3168efe6a5fa0f9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
