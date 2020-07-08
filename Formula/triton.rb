require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.10.0.tgz"
  sha256 "bda624f459cce4e3d9b8557270a3de6a375fd181151acc3f0d0d0962b60fb307"

  bottle do
    cellar :any_skip_relocation
    sha256 "21d5112b9f248c6a305953dd5cd3d2295baacf8b8c19fc247a10889ede4265ce" => :catalina
    sha256 "45a55e0e4e85d81fb6a731778a418b82b543ad23e193b43ee466f79a91fe2468" => :mojave
    sha256 "ff03483801c0896b7a147ca42204208a70b846c97f16dd30119f2c8c96ebc73e" => :high_sierra
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
