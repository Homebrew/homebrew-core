class Utimer < Formula
  desc "Multifunction timer tool"
  homepage "https://launchpad.net/utimer"
  url "https://launchpad.net/utimer/0.4/0.4/+download/utimer-0.4.tar.gz"
  sha256 "07a9d28e15155a10b7e6b22af05c84c878d95be782b6b0afaadec2f7884aa0f7"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c86234c30c090ef832ddfb4c4b52117f6ef31956246abb311645860154cc6fc"
    sha256 cellar: :any,                 arm64_big_sur:  "bb50ed1a38ea9dc66c442261dbf8f6e517b9d374869e647d2136c580a47f7aca"
    sha256 cellar: :any,                 monterey:       "8f1bc7e7ea1445618ce50bfcc7c8aea1570ea70245d17e47b4ac7d9d6d68e295"
    sha256 cellar: :any,                 big_sur:        "35c830b5c976738af7451ff1d110028a351e1b16145efa54ba0d042ff43e8980"
    sha256 cellar: :any,                 catalina:       "58144b80218183cb1cb0bdccd87baf86a4bddbab8b3107a2197227a15b6a4f27"
    sha256 cellar: :any,                 mojave:         "01a5bce5e1e818932e0870eaed8586a23f3a6ca24504011005fc03d86992f63e"
    sha256 cellar: :any,                 high_sierra:    "ef1faac8b5226cad7b83369c5139a370543316fd43102f7a8ccd15ab63f4fe6e"
    sha256 cellar: :any,                 sierra:         "a2bb9673b9b7909dcb080f52ea6480d2d89f3ae0fdff3c599e17587ebce406e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44f6b1ef51bbbb0a61411585f06bc0d7e9d94083b04c11802f26ba2b2f36d8e"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Elapsed Time:", shell_output("#{bin}/utimer -t 0ms")
  end
end
