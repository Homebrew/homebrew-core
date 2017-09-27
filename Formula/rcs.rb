class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.9.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.9.4.tar.xz"
  sha256 "063d5a0d7da1821754b80c639cdae2c82b535c8ff4131f75dc7bbf0cd63a5dff"
  revision 1

  bottle do
    cellar :any
    sha256 "4db2b0c7c6e847a60a17bf7dd3c13b68e4c390bb93f51de7cc09afa5242ad4f1" => :high_sierra
    sha256 "a4da901d15710afc151c6bdf1fe0257ca7d0e7ecf9a0586ccee95127e87748e9" => :sierra
    sha256 "67cea3736a9840099458ab2a7572fe9b8eb8cfcaa73c15805cbefd13e8be3ea3" => :el_capitan
  end

  # Fixes use of _Noreturn attribute
  # This patch is a commit from the upstream git repo; will be in the next release.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3fff7c990b8df4174045834b9c1210e7736ff5a4/rcs/noreturn.patch"
    sha256 "ac2f5ad1df932361e19c6184d2dfddfbe7664184ac4c24a3224c85707cd4da9f"
  end

  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
