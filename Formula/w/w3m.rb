class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  url "https://git.sr.ht/~rkta/w3m/archive/v0.5.6.tar.gz"
  sha256 "8dd652cd3f31817d68c7263c34eeffb50118c80be19e1159bf8cbf763037095e"
  license "w3m"
  revision 1
  compatibility_version 1
  head "https://git.sr.ht/~rkta/w3m", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "e6e1ef7d78315e84a9511f4cce13565b1871e9c8fa10b98d474ddf41414aced7"
    sha256 arm64_tahoe:       "9bee09446ab7db97ed5d8ae4fc5e45f7c54b6b1a310b2ba1dd892eaa0abe6afc"
    sha256 arm64_sequoia:     "7afe20edd0af171e1808170cf2c1203ed8c8723952ddc8a52e78e89c6d99715a"
    sha256 arm64_linux:       "461e5b40f8ca09fd34e64acaf0f24c0891a800cd428a38a532ccb88c86dd207a"
    sha256 x86_64_linux:      "e93e73210b7b2d44fbff89a9f2b6cce2dd72de64028a17cfcff0a4decc7845f1"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-image",
                          "--with-ssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
