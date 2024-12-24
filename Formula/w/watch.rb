class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v4.0.5",
      revision: "f46b2f7929cdfe2913ed0a7f585b09d6adbf994e"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6a87db4955bd26f571c90378186d245a6dcc50a2c8b6c8026f69f81328679ec6"
    sha256 cellar: :any,                 arm64_sonoma:   "9d8b55c73a9b913186f6ef8dc7642e8a718b5edea93fc3301fff5f44ad42fe90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e3977aacd949425257bb08b9ed66125e4cdff76a6e5b2464718139bc966d8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f7ea5b77d12731688f4e2e72e8190f70c62763d4bdb94e8c30ea1c0625db9d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aac6404005a0953a1126687829863e19fa4d0f02acc4e58d8d099615bd9d014"
    sha256 cellar: :any,                 sonoma:         "58baecc442fe806ece26dcd2c055532f226b8a06a732d32392c0858c56a6ac67"
    sha256 cellar: :any_skip_relocation, ventura:        "80193cc3557144f620767de324af7f45bd0717496b81d8d09f811cf0e9e7397c"
    sha256 cellar: :any_skip_relocation, monterey:       "f52987abe01c3e3a09c5608d02fd8a4714632f4256ae58c79d4a32f41e42669b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d61077f4bffe12e0132a86c138630d2c422932272a61959ab1a01e8b7c244edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03aa0061c8707c4d31402f1697429c7619e08e29221de08eed00ec9a26d3bc1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

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
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
