class Skalibs < Formula
  desc "Skarnet's library collection"
  homepage "https://skarnet.org/software/skalibs/"
  url "https://skarnet.org/software/skalibs/skalibs-2.16.0.0.tar.gz"
  sha256 "90a3deda94a40d7d6a4495fe6feaf91c0185e0428d59cbd150a1a468741269aa"
  license "ISC"
  head "git://git.skarnet.org/skalibs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f9ea2841a10c1800bfe3b67edc23d2949f5f9d9cd6d449f9369f946451e7ba04"
    sha256 cellar: :any, arm64_tahoe:       "4f07e606d0e15631dcfc2f81c210857feed5e4281ed28a5ca31e411eedf7f0b5"
    sha256 cellar: :any, arm64_sequoia:     "1d2ae8a01779354d206527671c810e1be4d62d662c9d24803b6e84d6583952da"
    sha256 cellar: :any, arm64_linux:       "ec8445c97a6082844f919e2c4599e9c524b4ab85bfc6d3fe2949da9efbf06687"
    sha256 cellar: :any, x86_64_linux:      "c02de2dbba6a95bebabd422e6b7ceef7ceca626a2934ea1f047f15a2b29e5aaa"
  end

  def install
    args = %w[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <skalibs/skalibs.h>
      int main() {
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lskarnet", "-o", "test"
    system "./test"
  end
end
