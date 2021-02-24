class Trimage < Formula
  desc "Cross-platform tool for optimizing PNG and JPG files"
  homepage "https://trimage.org"
  url "https://github.com/Kilian/Trimage/archive/1.0.6.tar.gz"
  sha256 "60448b5a827691087a1bd016a68f84d8c457fc29179271f310fe5f9fa21415cf"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c276cb15466c11675e091c6a0f86cd214c223e508ce05bcbe9ea673a81655a1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c11c650219774302d6337e0764c405f533999ef136f266c4ddccd9f163848df0"
    sha256 cellar: :any_skip_relocation, catalina:      "26b150cd030648ed8ca36448b80299a51c90d5487b7a9ad4d449b8540428e9a7"
    sha256 cellar: :any_skip_relocation, mojave:        "1e1d69b2eb37119b8e9078476443a4944ae84eee458d7346a9ad1a8cbd3a9e75"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0e6f831f6c28348eb20f29e1b12bf9b6dcdbf665bf896f377c4d840aae967715"
  end

  depends_on "advancecomp"
  depends_on "jpegoptim"
  depends_on "optipng"
  depends_on "pngcrush"
  depends_on "pyqt"
  depends_on "python@3.9"

  def install
    system "#{Formula["python@3.9"].opt_bin}/python3", "setup.py", "build"
    system "#{Formula["python@3.9"].opt_bin}/python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    cp test_fixtures("test.png"), testpath
    cp test_fixtures("test.jpg"), testpath
    assert_match "New Size", shell_output("#{bin}/trimage -f #{testpath}/test.png 2>1")
    assert_match "New Size", shell_output("#{bin}/trimage -f #{testpath}/test.jpg 2>1")
  end
end
