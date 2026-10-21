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

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "43ffd7492dd24a7ab0ca827bb0d6a341f53f0a8c2ecd9df3a0e7ccc13d37cea3"
    sha256 cellar: :any, arm64_tahoe:       "6a4f65773f826eee44097f7dc87595becdf9eb9e4cfda3582c28548a46815889"
    sha256 cellar: :any, arm64_sequoia:     "00dbd553b6e18ce7463ee3b5b16ab9eb3faf64a0ff6fa4876400ac11080651f4"
    sha256 cellar: :any, arm64_linux:       "948a75f16574c51e2524621ebf826309154d417d2dc526498b464911004722ce"
    sha256 cellar: :any, x86_64_linux:      "ada75abea63fda079ef0ad452a8d6cfafb7cf79ce3f4a707711380b50abd2629"
  end

  depends_on "python@3.15" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    type :unofficial
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--with-python=#{python3}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
