class Shivavg < Formula
  desc "OpenGL based ANSI C implementation of the OpenVG standard"
  homepage "https://sourceforge.net/projects/shivavg/"
  url "https://downloads.sourceforge.net/project/shivavg/ShivaVG/0.2.1/ShivaVG-0.2.1.zip"
  sha256 "9735079392829f7aaf79e02ed84dd74f5c443c39c02ff461cfdd19cfc4ae89c4"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0aaf1bb18c79c32a37185bca6b61d84f088d434be24e051128d48f6c8d4e779f"
    sha256 cellar: :any,                 arm64_sequoia:  "65aec8af6d55bd324b1590d4e29d30cc3a3da50c4492bb6f5dd0c8906bb0fd58"
    sha256 cellar: :any,                 arm64_sonoma:   "b6ef4461bec2d6b8a9e7e0cf2aaf02b7fc871bddcbf631318a4f7d7e5b1fa530"
    sha256 cellar: :any,                 arm64_ventura:  "b662c161700f2148a68a780888457dce0567614772e8aa441bde37a1f40ebc4c"
    sha256 cellar: :any,                 arm64_monterey: "ba0da5a73889923ba7031099a70d0e69d683fbb90583b6c65d4335deb88323b0"
    sha256 cellar: :any,                 arm64_big_sur:  "8d928dc2b52759bad7394d50cc55b1b6d512fbbbba9fe902cb5e3296bd0e915a"
    sha256 cellar: :any,                 sonoma:         "1c8c3d89d312804881bb803c2e8d372af69035f4a4a66ee1a69dde8e531be29c"
    sha256 cellar: :any,                 ventura:        "0f6298f4a9c2aa7bb11d2b9d6a16a8c14a5699e333e41a167f356e7ae140b77c"
    sha256 cellar: :any,                 monterey:       "9c8b1b85cf294a3cbf74955d7b1f526069d8ddfaf239ecf1b62c21aaa4190675"
    sha256 cellar: :any,                 big_sur:        "2d89164bed390c7556dbf88d65bb25775ea17bc04e1e4bfb026792ef64fba6ed"
    sha256 cellar: :any,                 catalina:       "b7c8f247b6db49cd1cabd2efd39d034c25d727f27bce09a329d9cc3c8e36a621"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c0b735943a8d9d52d9089d252a1b7fb0d9aa4cb6630e24a284d082f0a29c6016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5c74db54f64e3a75e394cba457cd969612c741de20f12b5941af967db03470"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Apply upstream commit to fix build on Linux. Remove with next release.
  patch do
    url "https://github.com/Ecognize/ShivaVG/commit/fe3bb03d7b03591b26ab7c399f51edcd130f0f4e.patch?full_index=1"
    sha256 "f4eb595afb053eb0a093dcf50748b54e01eff729f4589f82deb8f6f2ce8f571b"
  end

  def install
    system "/bin/sh", "autogen.sh"
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "configure", "$LDFLAGS conftest.$ac_ext", "conftest.$ac_ext $LDFLAGS" unless OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-example-all=no"
    system "make", "install"
  end
end
