require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.89.tgz"
  sha256 "9104dd1a760c0772b4de29785c2e793a8462eab84886de512960f9b94ea466c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d319a6fdf4967c2fb648b422425b4025e6b33daed88748825abced7c9d58c359" => :mojave
    sha256 "8ebdeb5af8fe172cf14028988e650ca31000fc8b9d77e59a108da0ce327b7db8" => :high_sierra
    sha256 "8868c229377c61195bea9c5bb2a561c8bf355a9b98505ea522ae842383f51fc0" => :sierra
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
