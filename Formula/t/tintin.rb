class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.61/tintin-2.02.61.tar.gz"
  sha256 "640b4823b6f24ada6d417311bfd6263ab13be2422573c3b4ad4352223b535d88"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1b32873045afd7f28de23d1f2e7bb8cf6d2443b5be875a075e9788f338f941b0"
    sha256 cellar: :any,                 arm64_sequoia: "a7173fdb565b12114bf44ab36fab43de5d51d1fa31210463fb4dd895d880b87b"
    sha256 cellar: :any,                 arm64_sonoma:  "29429cbfdd5bfa3b8e05c7d047d1be43eab5b206cddd3d15e9075f3f82c1674d"
    sha256 cellar: :any,                 sonoma:        "ed898b18d439132d6275d38e94a2f4dacc7d71de933bfe637562782e32e06def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f935a18a99c16d1f8f9544970620f0e06877c933f5ca081b7dd30d4eedf3de29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09c43f08ffc98738dff09bbec41da931652f2ab68f932c6ac74f5271313bc170"
  end

  depends_on "gnutls"
  depends_on "pcre2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
