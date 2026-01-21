class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  url "https://git.sr.ht/~rkta/w3m/archive/v0.5.5.tar.gz"
  sha256 "b271c86b13be2207700230cb3f9061271ea37fd1ace199f48b72ea542a529a0f"
  license "w3m"
  head "https://git.sr.ht/~rkta/w3m", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "54a28ede9af7af24957e089d7e635cbddc3d647bb858663647cd8cdbe9ac3346"
    sha256 arm64_sequoia: "6efda232c86351e6e4908c38199188d885c50b8854541bb5a1647685e7b67bb6"
    sha256 arm64_sonoma:  "256a0502e045c00f6ff2854f75c651e935eda90b58c737e79df1b4690be41406"
    sha256 sonoma:        "807cd2e2aec4f81dcd11a4e7fab76fb5fae0633960a5df3e1e36eed4f5cd3d7d"
    sha256 arm64_linux:   "82b720acc082358777064a290d20be4f70cd9a63a4e326d6e4f5d3143848f829"
    sha256 x86_64_linux:  "e5baafabcaf71e279b405695d142b3c54eafe192b266132adef55b67fbc42284"
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
