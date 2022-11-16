class Trimage < Formula
  desc "Cross-platform tool for optimizing PNG and JPG files"
  homepage "https://trimage.org"
  url "https://github.com/Kilian/Trimage/archive/1.0.6.tar.gz"
  sha256 "60448b5a827691087a1bd016a68f84d8c457fc29179271f310fe5f9fa21415cf"
  license "MIT"
  revision 3
  head "https://github.com/Kilian/Trimage.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8a431f153a9ebde3caaac7ce16403332dafa459476e7f2ad95863c87bd1941cc"
  end

  depends_on "advancecomp"
  depends_on "jpegoptim"
  depends_on "optipng"
  depends_on "pngcrush"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"
    system python3, *Language::Python.setup_install_args(prefix, python3),
                    "--install-data=#{prefix}"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    cp test_fixtures("test.png"), testpath
    cp test_fixtures("test.jpg"), testpath
    assert_match "New Size", shell_output("#{bin}/trimage -f #{testpath}/test.png 2>/dev/null")
    assert_match "New Size", shell_output("#{bin}/trimage -f #{testpath}/test.jpg 2>/dev/null")
  end
end
