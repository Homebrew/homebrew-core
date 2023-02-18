class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v4.0.3",
      revision: "806eb270f217ff7e1e745c7bda2b002b5be74be4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a0e9b20a5d963727fe871d036d36e8c6d9acd512f37afd89f2c776415df1e62"
    sha256 cellar: :any,                 arm64_monterey: "295f41f104c803e7f8eeb9143f78d9d0c3ab0a586a9b21ef10d51f35f6aa5134"
    sha256 cellar: :any,                 arm64_big_sur:  "f4be2f3608b91a6e1ec8d96301c7d1cc64e9f826db37c396f6145dd0c326cd80"
    sha256 cellar: :any,                 ventura:        "c46ff9d0553bf1e0b521ea918bae5c37947082a60c429572d2684f3bf0adff23"
    sha256 cellar: :any,                 monterey:       "e1fe02414d939a45b709243ccb5689d9619afbb3e7208af3f636c3b5a32dd52b"
    sha256 cellar: :any,                 big_sur:        "a69794ac246a20aca413883e44fefeb34557caa52e6c655bba6822df140a3ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce1c3480a970bf4415aded2f6b8ec57744a1b25e385ac32f705a681e4b9b4b2d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "src/watch"
    bin.install "src/watch"
    man1.install "man/watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
