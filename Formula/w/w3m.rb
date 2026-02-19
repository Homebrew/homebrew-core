class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  url "https://git.sr.ht/~rkta/w3m/archive/v0.5.6.tar.gz"
  sha256 "8dd652cd3f31817d68c7263c34eeffb50118c80be19e1159bf8cbf763037095e"
  license "w3m"
  head "https://git.sr.ht/~rkta/w3m", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6d5d85da3996059056c2306f74e1fc99b2d4a44f9d36ec27bf4773b0b7d526ab"
    sha256 arm64_sequoia: "dea325c341124209c6ef09dd4f46a4935d135ad64b4189a113fa8a10f797483c"
    sha256 arm64_sonoma:  "20f95afb096ae876e27f7c727504df76883f96f1ed9a01b165afb5ac974ca1fd"
    sha256 sonoma:        "e211672f7fbed8d9b27e9a2d06b8e0c20913e604c3e46977cfa5001fd736953d"
    sha256 arm64_linux:   "8c421b7a978bf9271b31a6957f8683b04669552a7592e88208c9c613086ab51a"
    sha256 x86_64_linux:  "abb3d05a8cb940c9b8ae94845a6c143ad8a5b3014e56349a81979e9c1783f3f4"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-image",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
