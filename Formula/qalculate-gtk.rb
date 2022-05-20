class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.1.1/qalculate-gtk-4.1.1.tar.gz"
  sha256 "8bf7dee899ba480e4f82c70cb374ed1229da28f7d3b9b475a089630a8eeb32e5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "722b1a22080a10aa47546cf768a6d63fdec1b0cf0af98c944ac88d673b0187ae"
    sha256 arm64_big_sur:  "a1932d522b8934456006f107edf3418a41edf9668da7c8d428c4995fdc516bcc"
    sha256 monterey:       "8dbc367a613c9b33905a363ae4ab48c29bacae46ddd5ea98483d2fdf017fde13"
    sha256 big_sur:        "b28eda4950ce783a0c37d3434b8e6d71c9e18d875d53db97ba1fd55d3e9f3f3f"
    sha256 catalina:       "0f4aad7f1afd170b715e3fa5bbcea056a64f1801f3a9e4253f38b63f3fef6887"
    sha256 x86_64_linux:   "abc669e4a20587300d23f0fde4b9c3e9e90f2b69182c794a4e68f336736ac34c"
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
