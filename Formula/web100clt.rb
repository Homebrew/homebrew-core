class Web100clt < Formula
  desc "Command-line version of NDT diagnostic client"
  homepage "https://software.internet2.edu/ndt/"
  url "https://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz"
  sha256 "bd298eb333d4c13f191ce3e9386162dd0de07cddde8fe39e9a74fde4e072cdd9"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a983c631a65d1ba764cf98ffc77ffbaabc1cf17625401702c8e6902a32ab7a46"
    sha256 cellar: :any,                 arm64_monterey: "0f11892f73529eceb8c6b1fd51c52e7c71b9a3a6bb3ae3f4dfc876c6fbb085d2"
    sha256 cellar: :any,                 arm64_big_sur:  "e6fb064b785043092357a6ca59164fad4ddb9be375f84b466a307b6af724d994"
    sha256 cellar: :any,                 ventura:        "8e994ec872e3ea4d0f1faf771ad42cad2734764c3eba93aac468845f3a1084e0"
    sha256 cellar: :any,                 monterey:       "2e4e41297ba21f0934b509b1a4f593c327390a457956be735fef597d1d4484a4"
    sha256 cellar: :any,                 big_sur:        "d4872b871f3d043038fc48d815196f2207203afb5df034b942c6488c83520501"
    sha256 cellar: :any,                 catalina:       "6674131c694ef7d4b8f0bc6fe8342ddc6e015b180efcf1f9452366cfb5eaf2d9"
    sha256 cellar: :any,                 mojave:         "d0657f34a029afff0189246744dd03d276ea9091e61b6dd208aea81b7e58cf36"
    sha256 cellar: :any,                 high_sierra:    "d6d8ecf4d6e7aa7da29fab7d2fe58db4c6da2da60b777be22d12854c15ea0887"
    sha256 cellar: :any,                 sierra:         "a6c81629d7e8171694cc14ebd5a1fc2280f23643be442f1103ac5a84403e344a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e17a9830b0b6458263ce8851ed8c8f98d8c2b6bd4b8998e7e82fe88dbaf918"
  end

  deprecate! date: "2022-10-11", because: :deprecated_upstream

  depends_on "i2util"
  depends_on "jansson"
  depends_on "openssl@1.1"

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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    system "make", "-C", "src", "install"
    man1.install "doc/web100clt.man" => "web100clt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/web100clt -v")
  end
end
