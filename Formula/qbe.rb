class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.0.tar.xz"
  sha256 "257ef3727c462795f8e599771f18272b772beb854aacab97e0fda70c13745e0c"
  license "MIT"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/qbe", "-h"
  end
end
