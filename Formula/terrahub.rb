require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.56.tgz"
  sha256 "2cf927dbad6f326ba89dad2dd4b62eb3938fe18289a76f7252dc19c117359130"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f93672f3526a5595c65a6be492b7bddf4bc3b4848ee3a911d7c732f1b07ec1d" => :mojave
    sha256 "63f5818063a0f10aca8baa8d01b82cf95553a7f1fafc9ddcf6a3ca017493ada4" => :high_sierra
    sha256 "e7d2f7bd2a44a6265f9f0e86f6b45d957432a3f3e072b17f1e9ad2561ed6941f" => :sierra
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
