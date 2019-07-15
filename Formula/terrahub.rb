require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.96.tgz"
  sha256 "15efea0a2e8066b2a217250080b03e82b61e4154712789d383b30c449d0cfbe4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cc731d7d75d3e09a4d86f64e9eac65bfb5c3c7dca546fde454d7a7ff31a9071" => :mojave
    sha256 "fd6df2c051a9c86da2f1fe2bc0c594c7beb94c0c07e35097c1bb6a11ddffd134" => :high_sierra
    sha256 "59d43f48e575d7313f910c3b9a5f534337b4f0d9eb9e2aae42107b5bac8430f0" => :sierra
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
