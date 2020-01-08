class Ydiff < Formula
  desc "View colored diff with side by side and auto pager support"
  homepage "https://github.com/ymattw/ydiff"
  url "https://github.com/ymattw/ydiff/archive/1.1.tar.gz"
  sha256 "4c749204d1368557e74392845de22155201484edb2fdb5f97730cd6282c2dcca"

  bottle :unneeded

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    diff_fixture = test_fixtures("test.diff").read
    assert_equal diff_fixture,
      pipe_output("#{bin}/ydiff -cnever", diff_fixture)
  end
end
