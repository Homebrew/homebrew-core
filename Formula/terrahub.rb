require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.47.tgz"
  sha256 "d2c66e3beaf28df2953f3830b771f1a34596ef51adaea321fe12ee39ada62b43"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8fb1ab5d692f7c6eb00c58882edfe883ed1b7bc130fcbacef2c59a2b05939054"
    sha256 cellar: :any_skip_relocation, big_sur:       "637b0c5d0b5bb4842335e447baa3d9cb75e50435c402669e69411b2c927a750f"
    sha256 cellar: :any_skip_relocation, catalina:      "35e7d2255110ab2aa7e3cd1d15237d3caa245f7f9103da07a1102d92d54c1730"
    sha256 cellar: :any_skip_relocation, mojave:        "65cc91be46785198944a1c383672c2cf1b200c261f9130dbc58910cb760a023e"
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
