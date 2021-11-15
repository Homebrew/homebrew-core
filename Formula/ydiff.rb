class Ydiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://github.com/ymattw/ydiff/archive/1.2.tar.gz"
  sha256 "0a0acf326b1471b257f51d63136f3534a41c0f9a405a1bbbd410457cebfdd6a1"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6496ac2da3fe8681060dc732141f174db77cca1f3a8fe7aeffa8201ba2638c1b"
  end

  depends_on "python@3.10"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
