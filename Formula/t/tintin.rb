class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.60/tintin-2.02.60.tar.gz"
  sha256 "b638031d56029ae03365b81e6ef9069837a71a4fb8fb2d52453261114a76cc41"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c963d41b41220fa59dd9501af58cd4413d65cbb93da3efb8fa8e19b8405b1f0"
    sha256 cellar: :any,                 arm64_sequoia: "3f5f2ea6f21237bbd0ff590dcfd5ab6690965925a5d3d72abd731dadf4aa8b52"
    sha256 cellar: :any,                 arm64_sonoma:  "3c598cbc2d82074a8ddd339e73f2f38726f4985b88c27fd2d79e00f8397ba1fa"
    sha256 cellar: :any,                 sonoma:        "b60885656a80c04a6a1542ed2ef6e55976c55e679fbc82877fd4f614761f0ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "796d114b742a1096b8c4514c2e3b5017ea3b6e7cea366610df47a5fafac0edbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9be808404bcf82a30c32258f3ccb5ded69d1e510fc4265b56a2da85866d448"
  end

  depends_on "gnutls"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
