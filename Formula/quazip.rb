class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "http://quazip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7.2/quazip-0.7.2.tar.gz"
  sha256 "91d827fbcafd099ae814cc18a8dd3bb709da6b8a27c918ee1c6c03b3f29440f4"

  bottle do
    cellar :any
    sha256 "24f50a91d05765ba1c92dc2c804060b5143b65de835ec5d236c5ee7ec61d23c5" => :el_capitan
    sha256 "d2827d0c3f6777487b83331ac78de8849330443a9e9087d31df4cea1abc971c6" => :yosemite
    sha256 "09deaa6657f2465b631b2f19697806f284c6ce328cdcd26bc23cdc3f21261c2f" => :mavericks
  end

  depends_on "qt"

  def install
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      spec = "unsupported/macx-clang-libc++"
    else
      spec = "macx-g++"
    end

    args = %W[
      -config release
      -spec #{spec}
      PREFIX=#{prefix}
      LIBS+=-lz
    ]

    system "qmake", "quazip.pro", *args
    system "make", "install"

    cd "qztest" do
      args = %W[-config release -spec #{spec}]
      system "qmake", *args
      system "make"
      bin.install "qztest"
    end
  end

  test do
    system "#{bin}/qztest"
  end
end
