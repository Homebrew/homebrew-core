class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v4.0.0",
      revision: "61825a5cc56b40c4afffd8c880b641210b05b3b7"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99135b41e5c85d6faaeaa3b3f9c74b17eea68d1394b639e3f4824ed4a582e9c4"
    sha256 cellar: :any,                 arm64_big_sur:  "4560b743e716fa5aaff0b809fbf8e0fbcc9c71f4e4f502b77acb2f9130b846e0"
    sha256 cellar: :any,                 monterey:       "2133244ca4acb47a37f24fa3930c5ab7d200b98d0d46fb80a7fb459373389e0e"
    sha256 cellar: :any,                 big_sur:        "77383edb8de69055e0156ac24ba26f9c786b0d40e72d8e72a2c068d36f64c45e"
    sha256 cellar: :any,                 catalina:       "32271afc05e243444040094864b075f61079a3464197699870b5026d4b3f62a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b323f891f08beffb572b77b70e371906ec9a263de9176bcf444e5d91c41719"
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
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
