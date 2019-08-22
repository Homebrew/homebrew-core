require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.4.1.tgz"
  sha256 "8a958b19dd18e78ec29fc70343e4bc29cfe1ee3ff8d77f4cc9508d8d565faaa3"

  bottle do
    sha256 "45752e31291427b1ef3d8db835b835b8798a53fa38b97951255e9f9a4b6b91cb" => :mojave
    sha256 "1a4cfc9a8797382aa0340b3276125b221160d6f411d25990d3938c291e5010d7" => :high_sierra
    sha256 "97be58a61a5a30dd83e35c1c2a98897259653c2b42e4ce9d2fdf46af60c27cc4" => :sierra
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
