class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/65/44/c2aa8743cada222eaede6b9bd4b644e84f04eaa6dede2258ec7562b705d3/yapf-0.30.0.tar.gz"
  sha256 "3000abee4c28daebad55da6c85f3cd07b8062ce48e2e9943c8da1b9667d48427"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c35f2e09c0d2ec13eb3372b99d149e821695f9657a4b0a77f4f9936837e9a8d3" => :big_sur
    sha256 "1e2e3659b521d218c9720c5c81b0a7a8c48b27844acfb391aaf2abc24809e84c" => :arm64_big_sur
    sha256 "c7595c7ea199301a266e69b60acda9a7497d2d4de333f4dce36ca17a487acb43" => :catalina
    sha256 "8de973e622e29c2d6c9d1ba1d8c15adb8645b09fd14f22ca01ad156533124109" => :mojave
    sha256 "5d489433ca30742c5569ba46ff7ae6a23f3971035d7f5bf35bb3486979cf4414" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
