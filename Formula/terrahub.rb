require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.74.tgz"
  sha256 "5206b8c9d7aeb5924719b67450ec0d2724905749c7e6968973908f00fc1562f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "93605d312f1d2d28e97a059f125b204cf14f42f08fdcd9c0253bcf5c30fb7df8" => :mojave
    sha256 "ca78d18ade34dc27c6a9adbb17b5715487bdc6b3886ba23f8c9512548e8795d0" => :high_sierra
    sha256 "79de547287a24d7c24d96b79ed483b52452575dc259d58e6bceced166a6471bb" => :sierra
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
