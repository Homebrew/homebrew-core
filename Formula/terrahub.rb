require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.21.tgz"
  sha256 "e6df98304743cf9208f6339a81221c39940463190e49d0060db25c175c1be155"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2d029ded0766e901e0cc2b53bf9db01d2496ca6797ca59b69309ab07765fe27" => :catalina
    sha256 "8d000edb320a289df21f019d698d692241c5a7b3bccd4d346bdf4c51060294eb" => :mojave
    sha256 "8b6c17ac15624ae6a7af154203d64a85e8089f485600b98150216aac14d431b7" => :high_sierra
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
