class Trimage < Formula
  desc "Cross-platform tool for optimizing PNG and JPG files"
  homepage "https://trimage.org"
  url "https://github.com/Kilian/Trimage/archive/refs/tags/1.0.6.tar.gz"
  sha256 "60448b5a827691087a1bd016a68f84d8c457fc29179271f310fe5f9fa21415cf"
  license "MIT"
  revision 3
  head "https://github.com/Kilian/Trimage.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b91e61437a333afc5b0cc4cb826c219f1627654cf5effeda44b798e74ad4588f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7468766aaaae29118342d2f7b97c41840780acaf076d4b11809cdb7d9e226bac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67052e7accdb902e57af7b0be76ebddc211db1344943a94c8d0797f3c372b2cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "038ce676a77132923d46b5fd788aa8cc201b5857ce71cd2a2f014685c24f7df6"
    sha256 cellar: :any_skip_relocation, ventura:        "44321af857d63e850bcd091be2591791cd7446a02f8c76d3788ad376e3cec5da"
    sha256 cellar: :any_skip_relocation, monterey:       "678b217ac821be820b5ef8d291c5996016788d017ceaf306ccc337975f347e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4208f78fd4a3d15107916af8ceeac1a08b4ab1b9d9f8563adbe8d737ee1f0895"
  end

  # https://github.com/Kilian/Trimage/issues/89
  deprecate! date: "2023-08-30", because: :unmaintained

  depends_on "advancecomp"
  depends_on "jpegoptim"
  depends_on "optipng"
  depends_on "pngcrush"
  depends_on "pyqt@5"
  depends_on "python@3.12"

  def install
    system "python3.12", "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
