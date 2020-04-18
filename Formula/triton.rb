require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.8.0.tgz"
  sha256 "9db78ebac41b19501af6f5e2c4c8bb452006b8337b385031563d63764933fb1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "daa2bdaf7312d926f69ce66ca768593dea9cfb94e0e6eda9568d700e99e0b005" => :catalina
    sha256 "a0943d1584dd4abe73b409b260db8c830c1b14f5c97845f8d79fcc35aa16cb02" => :mojave
    sha256 "9b656ba4c57181766a04da5ccc8a0fb4a24849ba3b97729e3d62c9890759b6ec" => :high_sierra
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
