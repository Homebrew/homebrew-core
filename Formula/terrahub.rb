require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.0.tgz"
  sha256 "70154594a2182d00ed3b6036f2f30e81627f5fcb6a625d41a7fb3dbcc9165bcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "baf941487f2a10d79d60e9efe75bd4c265d8f92e6d9c256b4fa105e200b07524" => :catalina
    sha256 "41601b41eba78b53664f63af80ce0db02a5bd443ccc6653cd952171e627a1907" => :mojave
    sha256 "6e2de11ff488288aeb140e9bed3b481fd018789fcbaac81f8126eec3603b7a65" => :high_sierra
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
