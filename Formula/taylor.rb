class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.1.3.tar.gz"
  sha256 "eb763ad683535df32270cf96e3489c1d9a593516ab9e0224ca41e10946f33382"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "892f7e3145820f4ac482bef208b7a96435dfae38efe7bb2e1723b27a244c19cb" => :el_capitan
  end

  depends_on :xcode => ["7.3"]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    # Improve test once sandbox issues have been resolved:
    # https://github.com/Homebrew/legacy-homebrew/pull/50211
    assert_match version.to_s, shell_output("#{bin}/taylor --version")
  end
end
