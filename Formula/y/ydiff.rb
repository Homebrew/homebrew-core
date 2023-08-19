class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://github.com/ymattw/ydiff/archive/1.2.tar.gz"
  sha256 "0a0acf326b1471b257f51d63136f3534a41c0f9a405a1bbbd410457cebfdd6a1"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7716b4d96423f5e20605b126217b6b9778848b6a141caa85250b646fadf66a84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7716b4d96423f5e20605b126217b6b9778848b6a141caa85250b646fadf66a84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7716b4d96423f5e20605b126217b6b9778848b6a141caa85250b646fadf66a84"
    sha256 cellar: :any_skip_relocation, ventura:        "0192ef7a7b3f397d92ba05728af96356869e24fb4de784128b6864e75f891c97"
    sha256 cellar: :any_skip_relocation, monterey:       "0192ef7a7b3f397d92ba05728af96356869e24fb4de784128b6864e75f891c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "0192ef7a7b3f397d92ba05728af96356869e24fb4de784128b6864e75f891c97"
    sha256 cellar: :any_skip_relocation, catalina:       "0192ef7a7b3f397d92ba05728af96356869e24fb4de784128b6864e75f891c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c4e2ad3135cbcc5ac2478cd0a83d570e2f0d9e0921f2f0fff89d854c25c5a2"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
