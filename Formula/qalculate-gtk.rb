class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.6.1/qalculate-gtk-4.6.1.tar.gz"
  sha256 "b9c5e7f6510e8e7ab49fe0e0e8796148cf6ef3187f17cea7b19b71631df8a950"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "83fdb45cfc1481c8cc84bc30f237ee676c30419e5ac24c3daa1cdc3be152bf91"
    sha256 arm64_monterey: "a95ffe138128517750bc8bb9b21c8bdbdfe1f2c8d302ce9572c9d9db49754e05"
    sha256 arm64_big_sur:  "6f204d48542f2d70b8894619e23b47f3273e93b9aefbba6449fb7205fdefa448"
    sha256 ventura:        "34bd4dab3cc86e608ecf80727bc252c045a0037c1ae06b41fd2d9dffe670e19a"
    sha256 monterey:       "7ea36a05fea05d2f75770669a66a4bcb79eb8531d232d28b024d5ecf18a5397f"
    sha256 big_sur:        "381156f144906dfbdacc75daa986c29fb072a90e0dea5ebc731227c507db481e"
    sha256 x86_64_linux:   "e33e41366a6e2427baae137469b102b5a7919b3f91bd2e8b764e5d5c93f248be"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
