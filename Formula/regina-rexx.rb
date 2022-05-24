class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.4/regina-rexx-3.9.4.tar.gz"
  sha256 "a4002237d0c625ded6a270c407643f49738de4eb755b68abdbf69c3f306d18be"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "b54fa50c843942c79e745d3ce9468db9310dc70e973fa94e190e3a0fa0e5caf3"
    sha256 arm64_big_sur:  "ab27f3fe98ea089a93403c418f33f0b1698a47e1161b73118fcb24742e50d2f9"
    sha256 monterey:       "d4e4746bb04e0dfe7b6c01e83349f1dc896ba22571a95c9dffb6c07095bc0902"
    sha256 big_sur:        "c6cfcdf1d903dc27e38bb21c0d02fb846f3fc418cc06decdc449f7d512156502"
    sha256 catalina:       "2b98c5ca16915c08e04828749e7f75644d7b7e1121a64ec78411ef9e9603c294"
    sha256 x86_64_linux:   "7b44626961634ed07b0c215d78c345dcc1c97d0a36c9ea3a530aa78ca61b9d8b"
  end

  def install
    ENV.deparallelize # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      #!#{bin}/regina
      Parse Version ver
      Say ver
    EOS
    chmod 0755, testpath/"test"
    assert_match version.to_s, shell_output(testpath/"test")
  end
end
