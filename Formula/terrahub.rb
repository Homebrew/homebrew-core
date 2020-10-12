require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.36.tgz"
  sha256 "70fe9fdea7c7c609bf2d77cca32e3f145b7745ed2b3145a6d520d9b04a2accd1"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4eefb00ce4b831bcf7a6011dcf21cc82c7fb87d33a943bd0892ad3b5c653a0ed" => :catalina
    sha256 "995f6cec3f46e1ed0c9434a4de98b4d7aefcd06a4123506c64fa5fe576cabce0" => :mojave
    sha256 "3ed78ae756249355c646d08926a8bf2898d672ab8c86071a776f148962436f5d" => :high_sierra
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
