class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "https://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.9.tar.gz"
  sha256 "29010e3df8449e9210faf96ca5518d573af4ada4939fe1e7cfbc169fe9179224"
  license "MIT"
  head "https://github.com/kulp/tenyr.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7423a06a07cb6618597fb303682fcd78cd017265f221c41002bc334f180bc7c1"
    sha256 cellar: :any, arm64_big_sur:  "7b8b35a252d9db09b9ab058ffde1bef392c747b7e2940e9f35c436bf8329e1e4"
    sha256 cellar: :any, monterey:       "d7835b60738972c5deb0bac9cd4a2cf0b7a6cec663aeec0260a2024b25b5e476"
    sha256 cellar: :any, big_sur:        "ba35781ed62b538a435c64602786456562d489eb4e9b70c6393e512cb2e86815"
    sha256 cellar: :any, catalina:       "f98eebfa349c23b2ed1ee5cdd0bb7882fb7469e93ce5fd253fbdadb0cb96c4d8"
    sha256 cellar: :any, mojave:         "725a4444c154dcbe5c2c835a82c246e044ab71d1769c240a0fc376af0c36a71c"
  end

  depends_on "bison" => :build # tenyr requires bison >= 2.5
  depends_on "sdl2_image"

  uses_from_macos "flex" => :build

  def install
    system "make", "BISON=#{Formula["bison"].opt_bin}/bison",
                   "JIT=0", "BUILDDIR=build/homebrew"

    pkgshare.install "rsrc", "plugins"
    cd "build/homebrew" do
      bin.install "tsim", "tas", "tld"
      lib.install Dir[shared_library("*")]
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
