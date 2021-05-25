require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.0.tgz"
  sha256 "96d2f68caf6bb68187da619ccfa305f8d85126a2e5199b2830255a6b1fc9a67c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "794b472b3bf4bc30fc1f34c52856d122fcec3fdbf19b027818acee112460bdaf"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4a13bf55599a12405fe995f6205a5c89650b37edc724d7d6b950c43bd159a09"
    sha256 cellar: :any_skip_relocation, catalina:      "506183f304838197472fa6012308460e66365386ad38ff9c3cb748d0a9aff934"
    sha256 cellar: :any_skip_relocation, mojave:        "08bd0a1aad4c30e8086d13db84cdc154caafed7d10122da68b5190adde747a82"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
