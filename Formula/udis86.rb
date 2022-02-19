class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "https://udis86.sourceforge.io"
  url "https://downloads.sourceforge.net/project/udis86/udis86/1.7/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/udis86[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d21c7de8ded29dbf2218802883f3a2e702e338722345b06aeab3a5146b81b29e"
    sha256 cellar: :any,                 arm64_big_sur:  "97a5c453ede751fa70387f5c66f3c618bdc421d29ed1da6ec6e002b0efd7705f"
    sha256 cellar: :any,                 monterey:       "d3b5ae26039dad3f35b3ead709fb8ee9be23ccaeb619d0b009830e7d94e151db"
    sha256 cellar: :any,                 big_sur:        "d34571cf019e170edc18b80d678db9d27d1cbbeab7e4c1ba9e667868a1d3dd43"
    sha256 cellar: :any,                 catalina:       "6e9b87a5a4d1de46246e92bc536113a6a56ec0c4565c2c0c0d122eb34ff4025b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a15d4f3b8bad23184fdace5ddc482e4d1b5d7f98030791ecf91983ec909d5a"
  end

  depends_on "python@3.10" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--with-python=#{which("python3")}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
