class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.2.3.tar.gz"
  sha256 "027c7e98d752ad57d2714a1c148d2b044d91a33ced18cd1bf2d82a020788bdd2"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "25b1ead494bd427079b9ab833915b254703ca06ac1f477cf77dea9c1c1652731" => :sierra
    sha256 "6cb392931254429bce282878c43f7441e5aa03f8312afb3b48e19e77b63b2948" => :el_capitan
  end

  depends_on :xcode => ["9.0"]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    # Improve test once sandbox issues have been resolved:
    # https://github.com/Homebrew/legacy-homebrew/pull/50211
    assert_match version.to_s, shell_output("#{bin}/taylor --version")
  end
end
