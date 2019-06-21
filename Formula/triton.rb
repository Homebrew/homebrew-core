require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.1.1.tgz"
  sha256 "24a1f697ee71451893f108dba9e4a5a7830cefe22028d98b504b3d2fe65ab2fe"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ac5ad301b021c6e5ca98e44ef22c6f84d812fed18a6f66a2e1ebf3692d77134b" => :mojave
    sha256 "d88a47d97195784e7819e0f619f13054bb30227bf14210ff61fc23a0a278c0a0" => :high_sierra
    sha256 "93f600d3e1e5e55d8a92f6bd8d93d5a61d3cbe1d38d98695393fe15aeef3a475" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
