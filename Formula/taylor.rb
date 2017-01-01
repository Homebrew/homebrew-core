class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.2.2.tar.gz"
  sha256 "991657866ab39357321f198864dbd1acfc871e9d1b80543a27b78e84a5958e5d"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "25b1ead494bd427079b9ab833915b254703ca06ac1f477cf77dea9c1c1652731" => :sierra
    sha256 "6cb392931254429bce282878c43f7441e5aa03f8312afb3b48e19e77b63b2948" => :el_capitan
  end

  depends_on :xcode => ["8.1"]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    # Improve test once sandbox issues have been resolved:
    # https://github.com/Homebrew/legacy-homebrew/pull/50211
    assert_match version.to_s, shell_output("#{bin}/taylor --version")
  end
end
