require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.9.tgz"
  sha256 "4f56dfae79c96b8d7338388ae45680ee2cb574cee3bb9c48edd829d5230a5f27"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3345275d4d34296abbe898c9323bc6eaab9ec58adbd2578c9672b478ae0152d" => :catalina
    sha256 "35d57154e4b42d674dcb2c3afff1b150b1029573cad586bd32a2eb71b10887bb" => :mojave
    sha256 "b73d1dd621ccfdb1683ad1647adf7479ad9fc36436c902977cb45cd9c1186824" => :high_sierra
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
