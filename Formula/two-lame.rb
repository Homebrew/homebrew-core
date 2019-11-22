class TwoLame < Formula
  desc "Optimized MPEG Audio Layer 2 (MP2) encoder"
  homepage "http://www.twolame.org/"
  url "https://downloads.sourceforge.net/twolame/0.4.0/twolame-0.4.0.tar.gz"
  sha256 "cc35424f6019a88c6f52570b63e1baf50f62963a3eac52a03a800bb070d7c87d"

  bottle do
    cellar :any
    sha256 "9ba9f3afb14f2ac2fa911046a83ee50ed6a93d747f0c305788a61b4138e5fe5a" => :catalina
    sha256 "77d5c37574ecdf0d857e09f47e9de5eda3049fe8cd1486942a6a62a4baae6f06" => :mojave
    sha256 "153c7085434a1bce73b0ce704f37997179d6e53614a7014546b9b4d3f80dec97" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "simplefrontend/.libs/stwolame"
  end

  test do
    system "#{bin}/stwolame", test_fixtures("test.wav"), "test.mp2"
  end
end
