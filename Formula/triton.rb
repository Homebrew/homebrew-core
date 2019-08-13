require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.4.0.tgz"
  sha256 "ef9a3669a5787a1a975a39fd6fc684f8c7b7d768821bc8bc5f02fd0621da975d"

  bottle do
    cellar :any_skip_relocation
    sha256 "cec8c5ebe508525b39178c239c9c1c864d66df5f6a2a740f65ad2a866ab08b82" => :mojave
    sha256 "c1f1527f5e2dedc3132c6841add67437fb1dfe6f41538a2894aa0ca31e304d76" => :high_sierra
    sha256 "ab746681920c2818b117eb33e792f75edfcec916f40300aff0327171538f764c" => :sierra
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
