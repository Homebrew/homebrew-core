class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.6.tar.gz"
  sha256 "04b92514927abfb5b7814a203bd296e8b528ae759c755402427db4cbc3ddbc47"
  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "79f1f08181a4a3563a95e002068cde55db5dd83f1e67e4baa10937659d72bb97" => :mojave
    sha256 "7ed5a7f7573c9970216c21dc1586fef1107ea97e20f143dd11ee41c6627d13b3" => :high_sierra
    sha256 "0b734e40019ad537072b648526d08c6d34c669251ca5bb8b4c22a3c2bd3ea745" => :sierra
    sha256 "1b09019bb0131b4ce6599612e55a828d22390757473c22dceab47aa30671fd1f" => :el_capitan
  end

  depends_on "bison" => :build # tenyr requires bison >= 2.5
  depends_on "pkg-config" => :build
  depends_on "sdl2_image"

  def install
    system "make", "BISON=#{Formula["bison"].opt_bin}/bison",
                   "JIT=0", "BUILDDIR=build/homebrew"

    pkgshare.install "rsrc", "plugins"
    cd "build/homebrew" do
      bin.install "tsim", "tas", "tld"
      lib.install Dir["*.dylib"]
    end
  end

  test do
    # sanity test assembler, linker and simulator
    (testpath/"part1").write "B <- 9\n"
    (testpath/"part2").write "C <- B * 3\n"

    system "#{bin}/tas", "--output=a.to", "part1"
    system "#{bin}/tas", "--output=b.to", "part2"
    system "#{bin}/tld", "--output=test.texe", "a.to", "b.to"

    assert_match "C 0000001b", shell_output("#{bin}/tsim -vvvv test.texe 2>&1")
  end
end
