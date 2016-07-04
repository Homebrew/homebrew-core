class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  head "https://gitlab.com/procps-ng/procps.git"

  stable do
    url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.11",
      :revision => "de985eced583f18df273146b110491b0f7404aab"

    # Upstream commit, which (probably inadvertently) fixes the error
    # "conflicting types for 'user_from_uid"
    # Commit subject is "watch: Correctly process [m Remove lib dependency"
    # Preexisting upstream report: https://gitlab.com/procps-ng/procps/issues/34
    patch do
      url "https://gitlab.com/procps-ng/procps/commit/99fa7f9f.diff"
      sha256 "7f907db30f4777746224506b120d5d402c01073fbd275e83d37259a8eb4f62b1"
    end
  end

  bottle do
    sha256 "3bcef103b4c05c5bee8a1f77f02f2ea7e9fb5c7496681677245bd8abcce7fdb5" => :el_capitan
    sha256 "fa4fc04f62518328ec879c595156a115ec14dde46be23c4b9dd79da9a378f74e" => :yosemite
    sha256 "f4e6ab66a65524de9fcca757afd95d1178f21ef87be1b04f56beec25e8cb191f" => :mavericks
  end

  conflicts_with "visionmedia-watch"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"

  def install
    # Prevents undefined symbol errors for _libintl_gettext, etc.
    # Reported 22 Jun 2016: https://gitlab.com/procps-ng/procps/issues/35
    ENV.append "LDFLAGS", "-lintl"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
