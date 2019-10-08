require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.3.7.tgz"
  sha256 "ecb0499c3710b7aebda2263e1309cf2d7d734c47e424f5a33350927a66be46ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "a33a4e3cc494513ca10ff40083a14264ccecfa576654f015b666784eb0d0130e" => :mojave
    sha256 "4ea96e9ff8748de5fb0ee2ed833184414d2f4ea8e552158aaedf46a7ee9527c7" => :high_sierra
    sha256 "6af4238e7dd2d24e5910d2d8cd725a19e7f83b7e84dfa952510ed79b5822f92d" => :sierra
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
