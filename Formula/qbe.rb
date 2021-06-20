class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "git://c9x.me/qbe.git",
    revision: "6d9ee1389572ae985f6a39bb99dbd10cdf42c123"
  version "1.0.0"
  license "MIT"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/qbe", "-h"
  end
end

