require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.28.tgz"
  sha256 "81daeccf312d53c045a70a4d18178c1cf1eaf95a39d4bfddce1237a5b2f45573"

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
