require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.15.tgz"
  sha256 "67da9dc9ec83a67d128de0f6655513fde06ac7565e835ba69a1139660b075ae0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1a6056775775a791ac27763908062fae5688a92785108c150ea51045e678057" => :catalina
    sha256 "11c03d11f5ee6d35c3edbdf1d6a353b3f733c1b9dbc28bb722dbe09bba321302" => :mojave
    sha256 "31e17627be60888b0d237cf52ab18df4a560accfd4c695ce74687427ca1b3ab7" => :high_sierra
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
