require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.11.0.tgz"
  sha256 "42a49cb112ae91015116b360a3d75da509d459d6f03d3c5b4c38ed20b6436294"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc3b2c8389ebdfa1cb9e3bebe5d1a2be854bbad7ea1a244c802a00dd2fa44bd" => :catalina
    sha256 "126492ee85adc820c3d6b2fa1ab8a4b74d8446df287d7bb881472cf58909b3b6" => :mojave
    sha256 "7470699caad1f183221b1fd5be532a43662bb2dbbd06639d576bc1ffeca58967" => :high_sierra
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
