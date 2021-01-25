require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.12.2.tgz"
  sha256 "090b6b39359354ed19c4633dd7d4fa14f53d74a4d81449ec8535beeda0b5de22"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9eff2740d1ee43579704b15f6cc0ec3ded59d8f2c32991aef2e7dd4243081df1" => :big_sur
    sha256 "0d26455a277496abe72df7663120b893aecdcde8acb71a210dc85a5944707191" => :arm64_big_sur
    sha256 "0e80b4d4276d3e695321ce821101192f3b0becd70d7f4b90e31092cd2340cbb3" => :catalina
    sha256 "690b346b720a50ee036fe590e5b508f1d4cab865f918bffb9ad0a5eb15f142c1" => :mojave
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
