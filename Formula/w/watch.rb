class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://downloads.sourceforge.net/project/procps-ng/Production/procps-ng-4.0.7.tar.xz"
  sha256 "9d2021f47a4501c667862c9942a92d1953694b21d11bcd1702e83eb594e3d67d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2aa3ccedc5de11c238fcd45b82de1d48970d0e87647d8eccf7bf0d57489640e9"
    sha256 cellar: :any, arm64_sequoia: "ecb6d8ef08094cf29623dbb0c7f05242a028a9212eb5d6137cee63ec8ed20240"
    sha256 cellar: :any, arm64_sonoma:  "34c635e84f379450e89a0e580cb9ba8b74772cddf646ba5a98ad062f2536d492"
    sha256 cellar: :any, sonoma:        "b091a655de353105318060067c9b8e53a374d6d55400f82ac43f6cdd6534bc4a"
    sha256 cellar: :any, arm64_linux:   "2127c712b98cb520ddd6f18bf849beb15384bf5d006a817fc02a1245abbbb6c7"
    sha256 cellar: :any, x86_64_linux:  "99ad82fa064d217605bac375e89df8d274df7b4defc1f821db21bf715855e1e5"
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
