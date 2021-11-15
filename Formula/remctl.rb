class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.17.tar.xz"
  sha256 "2ca2f3c7808af1f6fedc89f0e852e0abb388ed29062b3822747c789b841dbd2a"
  license "MIT"

  livecheck do
    url "https://archives.eyrie.org/software/kerberos/"
    regex(/href=.*?remctl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "8b20a4f70e57a2da606bf67d22239dade23a10b4b277d3b71477bbf935a44a23"
    sha256 cellar: :any, arm64_big_sur:  "3e7967965694f25afffdb35ee5f99857811dc64be5bd321278300725248d41e8"
    sha256 cellar: :any, monterey:       "71d03a6a04bd587cd810655a533152bf9f30413fdccb271b403d5d66163eb003"
    sha256 cellar: :any, big_sur:        "c021ec96746bcec68298d67fb9ac2550b059a0b6626e331b79c26e8a18feedcc"
    sha256 cellar: :any, catalina:       "58267d5b4fc81b44c59521fce5a6c64ece78a67436d702741acaa6e656122caa"
    sha256 cellar: :any, mojave:         "3d05fc09916078097c4cf62021d1f92bc9df6aa89e4f8c5dbd6028877a640d84"
  end

  depends_on "libevent"
  depends_on "pcre"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
