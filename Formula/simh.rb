class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "https://github.com/simh/simh/archive/v3.12-2.tar.gz"
  version "3.12.2"
  sha256 "bd8b01c24e62d9ba930f41a7ae7c87bf0c1e5794e27ff689c1b058ed75ebc3e8"
  license "MIT"
  head "https://github.com/simh/simh.git", branch: "master"

  # At the time this check was added, the "latest" release on GitHub was several
  # versions behind the actual latest version, so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc698568672a1c839e4bc5fe3005ab92d9369de3cf25f81be62c90084b2093a7"
    sha256 cellar: :any,                 arm64_monterey: "4bbbfacf19e812a3f551b11c3dc6222b30cba2ff789d10b7a0d3431c1c7816f8"
    sha256 cellar: :any,                 arm64_big_sur:  "226b979de0b16040ceac8d43169acad561cc02de69fedbc3ce7608e08a8dcf99"
    sha256 cellar: :any,                 ventura:        "8f872bb0008a36d6941b551827ecfae6563ddbaaa2853b390569599a991746d1"
    sha256 cellar: :any,                 monterey:       "a58a7539db5ac84a45dac55d1718b539435b4364b154922b1a12ea689f4f8a0e"
    sha256 cellar: :any,                 big_sur:        "009a1fd5617b4964e7548754c9047688b3ffbc86a6c5e3acf816ce8462a3489e"
    sha256 cellar: :any,                 catalina:       "260d5b0236efa26ea9846b5a64807afeb6dda6c0c308f84a4cd0f891a1fa76e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff6b20047316c5efd516276d7029475379b026f43b446e1707e488cff52be10"
  end

  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    ENV.deparallelize unless build.head?
    inreplace "makefile", "GCC = gcc", "GCC = #{ENV.cc}"
    inreplace "makefile", "CFLAGS_O = -O2", "CFLAGS_O = #{ENV.cflags}"
    system "make", "all"
    bin.install Dir["BIN/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
