class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.1.3.tar.gz"
  sha256 "eb763ad683535df32270cf96e3489c1d9a593516ab9e0224ca41e10946f33382"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "d8985bb008d9bc04d8f0ba1857389d13ce708e6df1fe13d9a3068ecc9128ecf6" => :el_capitan
    sha256 "5701b33481fea36eef1240eb9107c63f045d0138998476a30f9692dc3d6711f0" => :yosemite
  end

  depends_on :xcode => ["7.3"]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taylor --version")
  end
end
