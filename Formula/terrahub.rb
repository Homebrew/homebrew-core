require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.48.tgz"
  sha256 "0d34d90dbbb22611653bb74f7f93abb4375c95353aa8b1acb8d33d5ed61fc152"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc80b9a46d6deac64fdcc86a87b9d38d3b1e73c8a3b44cb93e45ddfa9abfc0f1" => :mojave
    sha256 "25a6d4749df950ae84102c85c68dee1b13cc2af348a12423d75ec70fac9817fe" => :high_sierra
    sha256 "7356fb544504557ecb253a6d3b4243e4ca2f7b28c8d13bf067b81e4ca540dba5" => :sierra
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
        dependsOn:
          - ./vpc
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
