require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.40.tgz"
  sha256 "ce39d407cf207cdcc0c466141ccfa6c7cd9d0ccb4371f5eb40514baa86636343"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3f54c95e01bf455fdcfa9d611b5ffb2107883713d57bd417a9acbdbd9cdfd84b" => :big_sur
    sha256 "8d3ec469e865ec84a5df634b424bd6553d51593f28fb1bbca8edf34298917429" => :catalina
    sha256 "7f8910ea70fb61f12c60228d8a36034383fd1365bdec96e32bdba7dd03675857" => :mojave
    sha256 "3995a9a171cecd49b7a954cf1d6ea1977ca52511b54855be34a81735b19359d7" => :high_sierra
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
