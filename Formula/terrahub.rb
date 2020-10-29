require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.38.tgz"
  sha256 "10a5ad822c1377ec268447b0c5c2982e8fb4980174567f1f13e4119dd614f2a3"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "37f2d7a60a4cc51210cc298930a4f4a4e1d13ef3f60154a8a65221816624b7f4" => :catalina
    sha256 "c7a53ffafc8f3f814e966b82ec7dcb03f79c2f37cf3f54154742616c76c138d5" => :mojave
    sha256 "96bee4d4fa04e31ec85463e2751333afe0d329a2839f5f84c46cc61ff389ed80" => :high_sierra
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
