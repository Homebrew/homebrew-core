require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.56.tgz"
  sha256 "2cf927dbad6f326ba89dad2dd4b62eb3938fe18289a76f7252dc19c117359130"

  bottle do
    cellar :any_skip_relocation
    sha256 "001a505308037a2c6128212466112de153b80ea2672c58844f62f6127305fd3b" => :mojave
    sha256 "7c8e6916a1e8f93d5fa697acda2a3fd89abfefa206c2465cbb87db9a745a9dbd" => :high_sierra
    sha256 "b3543acfb68fd7f2be5d6dafde087e453b451b9bd0d7019e566f06c2ce2ec7f0" => :sierra
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
