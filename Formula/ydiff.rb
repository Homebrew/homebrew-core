class Ydiff < Formula
  include Language::Python::Virtualenv

  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://github.com/ymattw/ydiff/archive/1.2.tar.gz"
  sha256 "0a0acf326b1471b257f51d63136f3534a41c0f9a405a1bbbd410457cebfdd6a1"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ed345c77f5c6d4012ffd27af864750775d764d1755547395bf33c6e81d8a14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20ed345c77f5c6d4012ffd27af864750775d764d1755547395bf33c6e81d8a14"
    sha256 cellar: :any_skip_relocation, monterey:       "8cfafc1dfa19564f3322fca2f64a82545a942432b7ad995c99fcf32ce8986ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cfafc1dfa19564f3322fca2f64a82545a942432b7ad995c99fcf32ce8986ed2"
    sha256 cellar: :any_skip_relocation, catalina:       "8cfafc1dfa19564f3322fca2f64a82545a942432b7ad995c99fcf32ce8986ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0bfd77f8a27a1093ee647a2d9632fc32d13a00744bbfac2f6a6931107cbd39f"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
