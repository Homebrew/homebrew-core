class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-399.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_399.orig.tar.gz"
  sha256 "9db34ad0f53ddb1223d70b247c8391e52f3e4b166d6ad85426a4c47813d1b1e3"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b3619c9f1ff955055521052c6117f5cfff7785c8a5ab57fceb1d37bd65546c8f"
    sha256 arm64_sonoma:  "28a1331530edd423ad5d09aaf681468637c936296f6a74e57a4dc7c19be15a41"
    sha256 arm64_ventura: "648f6fd46f877c4cc9ec1a952974b20cadabb2568b297ff67940a582697c7258"
    sha256 sonoma:        "e0e252d8064a7ba2c8997f6dc64a7074f1559e891196e905dc2242f9d2e341bd"
    sha256 ventura:       "950dcadcc3c8ab1eaef9ac0409faffa7914a1fd2b344af5f0657299547c1129b"
    sha256 arm64_linux:   "8e46eb7f6b3b616825c7975964630d06b9108ad6c8debfd4337737cb06606159"
    sha256 x86_64_linux:  "1ff02296f611413e715865bc8fada1d87ef8cb6984ad02f3feba6187ff8be108"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end
