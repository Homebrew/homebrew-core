class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "https://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.8.tar.gz"
  sha256 "08dd2e5380de5ba23703f92621a0bc249d0f1fac8e581158572ed039dca72309"
  license "MIT"
  head "https://github.com/kulp/tenyr.git", branch: "develop"

  bottle do
    cellar :any
    sha256 "da43ae225d840b6b9848228b32cbd6bf57788ddf496d6caab2657b9da2134bf7" => :big_sur
    sha256 "d7534b8f75f3e9a6ceac1f1558b9446ad49af76e510075c989f37af79578f3b7" => :arm64_big_sur
    sha256 "0991aa650dda340466acc2a425ee4f8e87c29ae937eed4edae3c44c4680985c6" => :catalina
    sha256 "5fecaf3174f726e8387635af1c7607206f5a66a60bb7f1964dc5281a2473b9f3" => :mojave
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
