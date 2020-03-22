require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.27.tgz"
  sha256 "0fafbc8b67c6a9ff2e8bb31162d33e3bc7086a810c9711580f05a767452e2551"

  bottle do
    cellar :any_skip_relocation
    sha256 "769fd09afe985b16d270b72831fcb6f39ffba9a47d8cfe766ab68714a15684c3" => :catalina
    sha256 "dd04130eea0220c8893a73b7f6e2d2f3fbd132bb9323576b91c1579228f541cb" => :mojave
    sha256 "c230d3e2305a70c74ec75ee81b214ba9d8200abe3f8ac3076601034ebbd825f4" => :high_sierra
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
