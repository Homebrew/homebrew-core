require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.26.tgz"
  sha256 "1ddb89594ae44b481289e1e0a50c216cf403a1f673bb992a53c1031cd3777cc3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b1aa25a29913c1523314214a4743342f491d64c7238ad28c7b385e2108b0e43" => :catalina
    sha256 "11898b1d2f7db6666a6e33fcf6a28fa821630b0599ff7973b818465c88d7b170" => :mojave
    sha256 "21ac4d1c8edc24bbd5c525fadc388a55f65743164a8d107cff594fa6d34c9be6" => :high_sierra
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
