require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.21.tgz"
  sha256 "e6df98304743cf9208f6339a81221c39940463190e49d0060db25c175c1be155"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad141eed10287fcdaea93a5137a6b1622e6d4cc610dcb0e70fe890294a65c586" => :catalina
    sha256 "990fe35bc70c4bac769a9cdc3d790392da3b3b366c7e06b0ab1b6ef0f1a7b86a" => :mojave
    sha256 "44651f2b6330226718e611313336e7d186b0fb12eee459b4343071e61d5bcf55" => :high_sierra
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
