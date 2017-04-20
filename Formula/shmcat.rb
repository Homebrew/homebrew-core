class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "https://shmcat.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.8.tar.bz2"
  sha256 "43fbf1b62f22f7cfcfd21228225151441450441d47ca73c9c2951c9af5549dde"

  bottle do
    cellar :any_skip_relocation
    sha256 "01cab982f77ba84084219d9106a7dc2e15ea8f1386b6b1dccadfb3f731c3a5be" => :sierra
    sha256 "418a5aca4e039528a55706db8063808a0fa1dafb3d913376177735bbce1dc836" => :el_capitan
    sha256 "1ce5eef9d77925041ea91bc2c8d49572525369df7a037928c3eb83698a58a8a4" => :yosemite
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
