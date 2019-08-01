require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.3.2.tgz"
  sha256 "77928821651aaae0799c1d637737c8fb758c7229b7c3b84a38c21be1ed2f54d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3447ac9c7a1942ce088798a62a87e6b26f927c30b0d9c9d79ca990791696703" => :mojave
    sha256 "8b5488f2f0793779b74698352ee438faf0dc78485186a9cf99e58e2af32d864d" => :high_sierra
    sha256 "2993914eb7748fb2ffdb91f656786ca5f10151ccdf46d060ab0c855f5e937d5d" => :sierra
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
