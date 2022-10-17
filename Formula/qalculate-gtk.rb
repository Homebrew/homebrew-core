class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.4.0/qalculate-gtk-4.4.0.tar.gz"
  sha256 "a17f0266196851cb4a55a3ae5a84e1942f9116911495ef141135b6853a4d6fbc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "4ba400fc634794bc2b3cfbfd574408910495e0015394c8e031cdef3f75afffaa"
    sha256 arm64_big_sur:  "ff598e93d2687d61fbc0edda7ad7400d0f271c3434fb65d5870b3874a42413d3"
    sha256 monterey:       "2d3c9f989b13752d51a02c909cd559b13de798cdd5b488d04a77adc2505e188e"
    sha256 big_sur:        "b3c82ffd307806f743c9674ffcf4caef3d08beae456e459a576e5d7f921491b7"
    sha256 catalina:       "90fc39aee49357dfa12a63434afa01a4bc32565485e3f26bf8f0bfcd0b8f3872"
    sha256 x86_64_linux:   "9c4f0bf59943b79f9920b5ebf32f9525f14a2a0a2dd21e58e8b338a8c506374b"
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
