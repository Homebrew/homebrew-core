class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  stable do
    url "https://downloads.sourceforge.net/project/procps-ng/Production/procps-ng-4.0.5.tar.xz"
    sha256 "c2e6d193cc78f84cd6ddb72aaf6d5c6a9162f0470e5992092057f5ff518562fa"

    # guard `SIGPOLL` to fix build on macOS, upstream pr ref, https://gitlab.com/procps-ng/procps/-/merge_requests/246
    patch do
      url "https://gitlab.com/procps-ng/procps/-/commit/2dc340e47669e0b0df7f71ff082e05ac5fa36615.diff"
      sha256 "a6ae69b3aff57491835935e973b52c8b309d3943535537ff33a24c78d18d11aa"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c5d3d966dd480ec6c0db515cbc01609736ece1123e1069d1b99d5199431f143"
    sha256 cellar: :any,                 arm64_sequoia: "a2c77480716cdd27593a8a81fcbb7b1f8c19b9f1d82847e4328efb98703e2045"
    sha256 cellar: :any,                 arm64_sonoma:  "6bb0691e3d38e625b5842646d8a0c2439d5889a63dbf6a45a1455fd6c900dae2"
    sha256 cellar: :any,                 arm64_ventura: "e5b2fe0f325b928c9a448b350e626fe254e0c313e2dbcc69a582f231cf5bb0f4"
    sha256 cellar: :any,                 sonoma:        "bed3496e896be3b00ef559bf3bafbc0fc0bc94c2fc0383e72bb45dc9a714200d"
    sha256 cellar: :any,                 ventura:       "658ca1a1a072b329b96e394ff3b7640883dc5e0ad1e02a3b3f5fa3afc88f8a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1bae7ca78aebb0707c57f82ae5609f900f3e9ff14ce6e5810d6998883575d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6bb244d3c65a2710ac9922b4cd7d2bf25c22ebd7a865f26b7e32d512291efff"
  end

  head do
    url "https://gitlab.com/procps-ng/procps.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    args = %w[
      --disable-nls
      --enable-watch8bit
    ]
    args << "--disable-pidwait" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "src/watch"
    bin.install "src/watch"
    man1.install "man/watch.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watch --version")

    require "pty"
    output = []
    PTY.spawn("#{bin}/watch --errexit --chgexit --interval 1 date") do |r, w, pid|
      r.winsize = [24, 160]
      begin
        r.each_char { |char| output << char }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_match "Every 1.0s: date", output.join
  end
end
