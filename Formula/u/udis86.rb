class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "https://sourceforge.net/projects/udis86/"
  url "https://downloads.sourceforge.net/project/udis86/udis86/1.7/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/udis86[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "64411bb2fb41c08729313426c8753ca7d79932086111c970803ecf5a87b6d06b"
    sha256 cellar: :any,                 arm64_sequoia: "c8ace05db1e4342ac3920f58c3841e8952df549f1385bb7b76305c332073fd00"
    sha256 cellar: :any,                 arm64_sonoma:  "9dcbdeb6b295c79410cd870c01c87b7313c62252089a2b2821df27ceae2db586"
    sha256 cellar: :any,                 sonoma:        "96c8db68a32708148bbbdcbfdb0ed3144c8f118972eabdaca6d8ec49f868ba64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6468cbe7b75d58bd68d0907006195ce52159a18444febf1f260e19d81a1f08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4799d288d7a86e2b63f0a9c55d7b50e21bae0770b6a728542e09a1fbcd62c96b"
  end

  depends_on "python@3.14" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--with-python=#{which("python3.14")}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
