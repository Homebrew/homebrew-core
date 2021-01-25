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
    cellar :any
    sha256 "c021ec96746bcec68298d67fb9ac2550b059a0b6626e331b79c26e8a18feedcc" => :big_sur
    sha256 "3e7967965694f25afffdb35ee5f99857811dc64be5bd321278300725248d41e8" => :arm64_big_sur
    sha256 "58267d5b4fc81b44c59521fce5a6c64ece78a67436d702741acaa6e656122caa" => :catalina
    sha256 "3d05fc09916078097c4cf62021d1f92bc9df6aa89e4f8c5dbd6028877a640d84" => :mojave
  end

  depends_on "libevent"
  depends_on "pcre"

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
