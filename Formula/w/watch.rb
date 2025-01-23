class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v4.0.5",
      revision: "f46b2f7929cdfe2913ed0a7f585b09d6adbf994e"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2c77480716cdd27593a8a81fcbb7b1f8c19b9f1d82847e4328efb98703e2045"
    sha256 cellar: :any,                 arm64_sonoma:  "6bb0691e3d38e625b5842646d8a0c2439d5889a63dbf6a45a1455fd6c900dae2"
    sha256 cellar: :any,                 arm64_ventura: "e5b2fe0f325b928c9a448b350e626fe254e0c313e2dbcc69a582f231cf5bb0f4"
    sha256 cellar: :any,                 sonoma:        "bed3496e896be3b00ef559bf3bafbc0fc0bc94c2fc0383e72bb45dc9a714200d"
    sha256 cellar: :any,                 ventura:       "658ca1a1a072b329b96e394ff3b7640883dc5e0ad1e02a3b3f5fa3afc88f8a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6bb244d3c65a2710ac9922b4cd7d2bf25c22ebd7a865f26b7e32d512291efff"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  # guard `SIGPOLL` to fix build on macOS, upstream pr ref, https://gitlab.com/procps-ng/procps/-/merge_requests/246
  patch do
    url "https://gitlab.com/procps-ng/procps/-/commit/2dc340e47669e0b0df7f71ff082e05ac5fa36615.diff"
    sha256 "a6ae69b3aff57491835935e973b52c8b309d3943535537ff33a24c78d18d11aa"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = %w[
      --disable-nls
      --enable-watch8bit
    ]
    args << "--disable-pidwait" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make", "src/watch"
    bin.install "src/watch"
    man1.install "man/watch.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watch --version")

    # Fails in Linux CI with "getchar(): Inappropriate ioctl for device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
