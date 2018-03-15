class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "https://shmcat.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.9.tar.xz"
  sha256 "831f1671e737bed31de3721b861f3796461ebf3b05270cf4c938749120ca8e5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff73e6df8b663b4f382098ce75a9ec4634d4658c5378b3ad122de135e30d44ab" => :high_sierra
    sha256 "5ee7bcafe69d653421e29b56cf2e48a55874dc1e092e817a83cb446cda4acf01" => :sierra
    sha256 "1b6ddaf528253df2e2d5b93e97b6f4ade717ff8f3f6bcf829ed7cf9d9e682539" => :el_capitan
  end

  option "with-ftok", "Build the ftok utility"
  option "with-gettext", "Build with Native Language Support"

  deprecated_option "with-nls" => "with-gettext"

  depends_on "gettext" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-ftok" if build.without? "ftok"

    if build.with? "gettext"
      args << "--with-libintl-prefix=#{Formula["gettext"].opt_include}"
    else
      args << "--disable-nls"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/shmcat --version")
  end
end
