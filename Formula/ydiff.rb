class Ydiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://github.com/ymattw/ydiff/archive/1.2.tar.gz"
  sha256 "0a0acf326b1471b257f51d63136f3534a41c0f9a405a1bbbd410457cebfdd6a1"
  license "BSD-3-Clause"

  bottle :unneeded

  depends_on "python@3.8"

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
