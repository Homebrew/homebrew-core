require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.1.1.tgz"
  sha256 "24a1f697ee71451893f108dba9e4a5a7830cefe22028d98b504b3d2fe65ab2fe"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "44a27d9c64d619fafd04eefbca811a02454b40547ba4ec35407916f19226f99e" => :mojave
    sha256 "81b7cf38e96b063f34bc15256676931e4e789d73561e03cda139958be68984ce" => :high_sierra
    sha256 "cb6c17ce067953a6430a1a9bf176ec4179921bcfc79caecb207a21c495132767" => :sierra
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
