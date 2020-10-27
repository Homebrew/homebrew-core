require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.11.0.tgz"
  sha256 "42a49cb112ae91015116b360a3d75da509d459d6f03d3c5b4c38ed20b6436294"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c641a16f691b80643d5d9bf68056953dba80044956b87bef3269f008433bbb0d" => :catalina
    sha256 "64bf5b0274d9fd434c6d8d80489fd13ebebd1e2f1bd7acaed285fc2a4749b36d" => :mojave
    sha256 "0893698205caab0e12f9a75291649de97d2e409e850fec41eac0373d3ea05964" => :high_sierra
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
