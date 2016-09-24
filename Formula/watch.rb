class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  head "https://gitlab.com/procps-ng/procps.git"

  stable do
    url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.12",
      :revision => "e0784ddaed30d095bb1d9a8ad6b5a23d10a212c4"

    # Upstream commit, which fixes missing HOST_NAME_MAX on BSD-y systems.
    # Commit subject is "watch: define HOST_NAME_MAX"
    patch do
      url "https://gitlab.com/procps-ng/procps/commit/e564ddcb01c3c11537432faa9c7a7a6badb05930.diff"
      sha256 "3a4664e154f324e93b2a8e453a12575b94aac9eb9d86831649731d0f1a7f869e"
    end
  end

  bottle do
    sha256 "98cf549c8b1c06199e9f8baccdc1dcc3fc3c1f9a5195a1869de991598774d806" => :sierra
    sha256 "926d0be8053cf015dc06cf8fb4e6107902c2015acc8b69f1a77100034e078cfd" => :el_capitan
    sha256 "31b517c67875cbb8ca8bd8126af66561a8df0f61bee955ffdeac3eeb6021ec12" => :yosemite
    sha256 "fdedabfbc86a57b936be2ca1377c8749a6bce801baf74ef4444e7c75b9b6e0f0" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"

  conflicts_with "visionmedia-watch"

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
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
