class Web100clt < Formula
  desc "Command-line version of NDT diagnostic client"
  homepage "https://software.internet2.edu/ndt/"
  url "https://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz"
  sha256 "bd298eb333d4c13f191ce3e9386162dd0de07cddde8fe39e9a74fde4e072cdd9"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "468e4a26cc053096e867e4bfbf5eb93ea33bf2491a554dcf298567603b1d52f3"
    sha256 cellar: :any,                 arm64_ventura:  "52cb2bd3da41ea3c6da7d9c264d463e487ad8fa95dc2d76ccb0358300107da4d"
    sha256 cellar: :any,                 arm64_monterey: "aae001deb56d5d249facbae8823a119ab7e8ff238a9ba84f7b797b512b9c10f0"
    sha256 cellar: :any,                 arm64_big_sur:  "7d2d245b01a95a7c2e8a13ae79f02e21fd86a1aa68506fd14ee6399e96a7a640"
    sha256 cellar: :any,                 sonoma:         "507ba12fbfe02ddb6095c9c565153ae374c99a1b7ae868c26dcaadb91772e83a"
    sha256 cellar: :any,                 ventura:        "ddefb5a2bd32e1c06645651b7977840915c53dc25ac944d366cc48b5444342f5"
    sha256 cellar: :any,                 monterey:       "dde4401af05d6ff58b3dbc8790e761cc0eb05b49b6979a361a31faa200b785a5"
    sha256 cellar: :any,                 big_sur:        "ec806c67b45b6eeff25a02815b105c194a6dd62315e0060f0f23503588713aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe252e0a733f1a880896f255f7a14e96808f89f8f0f4e33625a4c93d58d1e7a"
  end

  disable! date: "2023-10-17", because: :deprecated_upstream

  depends_on "i2util"
  depends_on "jansson"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # fixes issue with new default secure strlcpy/strlcat functions in 10.9
  # https://github.com/ndt-project/ndt/issues/106
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/37aa64888341/web100clt/ndt-3.6.5.2-osx-10.9.patch"
      sha256 "86d2399e3d139c02108ce2afb45193d8c1f5782996714743ec673c7921095e8e"
    end
  end

  def install
    ENV.append "CPPFLAGS", "-fcommon" if OS.linux?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    system "make", "-C", "src", "install"
    man1.install "doc/web100clt.man" => "web100clt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/web100clt -v")
  end
end
