require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.89.tgz"
  sha256 "9104dd1a760c0772b4de29785c2e793a8462eab84886de512960f9b94ea466c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4f06873cf8dcb2fd00200da4da2192a7637263953890757d65d7636a6a4fc92" => :mojave
    sha256 "7b1ecc54b5920c539ed0fa92916c9a9fcdad1b550577a2ae3039241800d71ad8" => :high_sierra
    sha256 "8ec499387360884b497d1b46e10ac5d978d5fa228d45d6b8ccda67cca41baeb1" => :sierra
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
