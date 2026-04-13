class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://downloads.sourceforge.net/project/procps-ng/Production/procps-ng-4.0.6.tar.xz"
  sha256 "67bea6fbc3a42a535a0230c9e891e5ddfb4d9d39422d46565a2990d1ace15216"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e18cef797bea2fae7d4fb254c5e04f671f245aa8cf13f6dde6e8e73e8dc9b2f5"
    sha256 cellar: :any,                 arm64_sequoia: "cb2385d58eaa16939399bc3e5d63eb4eec867160324317cbf936bee9cfcfc8d8"
    sha256 cellar: :any,                 arm64_sonoma:  "f77561460720d4113a39394edadf007fa15e1ac5fc1af29b770973bb5145f832"
    sha256 cellar: :any,                 sonoma:        "df9d846e7d79ae58e6324eef960c20d8dd6d6f4e6daeba0d87ffbd84481ae6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1967de3c71371a3d0d2062d3a86e5724e8db863a6d13242a52980f1584c4ab41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01316c06ebb730cadb23fc62031039fda7d59cbacea80b41b021b28aa4ecd676"
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
