class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/v2.1.1.tar.gz"
  sha256 "6f0ee21c8605340cfbb458cbd195b4d074e6d16dd0c0e12f2627ca773f3cabf1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "253c680b90ff85e1c58b90bae9459ca89404726f6295b692934f294f3a6c2413"
    sha256 cellar: :any,                 arm64_big_sur:  "312df6bed7c751800af40d85f409f7b96296aa0968cc9a0d415f9fe4114a506c"
    sha256 cellar: :any,                 monterey:       "3c5e2b61923c6479c173367d357b0b6e072a24c0aa04ca7e02c2f28cdd9c9f54"
    sha256 cellar: :any,                 big_sur:        "6f0c7e2db3067e24f4480566d9cf80b9f47ef6099386205ca472a8ede717d3e8"
    sha256 cellar: :any,                 catalina:       "06ca0a9cc4c001e5136b14b210c7a37ff7ecb85e2f1c348a3655b325094ac697"
    sha256 cellar: :any,                 mojave:         "e2757e5acea92e205a10e738d6a084b37347a3be3e08f8a481607e9c48d22e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c212b093e54c12a0b8c8afdde6e56fd04fa15182a9a95633c72bcf5ec9b10388"
  end

  depends_on "libtool" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unibilium.h>
      #include <stdio.h>

      int main()
      {
        setvbuf(stdout, NULL, _IOLBF, 0);
        unibi_term *ut = unibi_dummy();
        unibi_destroy(ut);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    system "./test"
  end
end
