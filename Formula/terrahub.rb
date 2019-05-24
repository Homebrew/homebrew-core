require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.58.tgz"
  sha256 "f79df1ea134e126ff8bfc7b12d98b2ec6a12abab798c952e2d1502e49f5f5acb"

  bottle do
    cellar :any_skip_relocation
    sha256 "77bc43b1af94c49a2853e2a08f7dbe0927bb0824b77bc3246e4ee0cd2ae2d7f7" => :mojave
    sha256 "5b8bbb8203f8772f6b42d4de95bbd125526ee823f8576826134e35cba731ae42" => :high_sierra
    sha256 "4b3c95de152f56a77c84102929b0b48c93c2135cd8d88b3813395dc3e72f3cd9" => :sierra
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
