require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.2.33.tgz"
  sha256 "9159648ba6ef16afc540aac162425b9b1b7419952dfb3dfee6647287445375d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "76bafce33b0984bd9229f9e5f462b3cfec87816699d5a0b249ff8c702fb64d7d" => :mojave
    sha256 "cbe0df754a0cc23123a805296250edd4b3b8241cd751c40acdaa9101afd453c5" => :high_sierra
    sha256 "3519002eb0a711e3c352f4b8a498a540c8380beabd49e5fdf0de63823ce43b1c" => :sierra
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
