class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.7.tar.gz"
  sha256 "f28e031acb14a0e4ff924479a0fd0087d9a15948a440f03b2dcf002723ccfdfa"
  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e9b70722348ae97c9d4f08ac7b143fb4402be98feb48f9941f8ca1f4397a909d" => :catalina
    sha256 "0386483bf004ccb772897cb304589089c41ba56c926ac751badc6744924178a5" => :mojave
    sha256 "f04b6f86879c098dfd7e87a384a8fea3c0c30d1d6b50dfa1477295430bae1566" => :high_sierra
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
