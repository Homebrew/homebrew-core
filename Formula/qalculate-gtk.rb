class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.7.0/qalculate-gtk-4.7.0.tar.gz"
  sha256 "4500b9a6567868821f3d21f1403faf8491422bec1e5692397678a7fcc41a52ab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "3c33f0aebab360a84c05845de9bf9b185fb4e83768633cb7de7887a82e9e91a9"
    sha256 arm64_monterey: "667e9b0b0aee3e584e6eaae90b004819aacffaebd45c4795d2a4565deae7d76e"
    sha256 arm64_big_sur:  "fc425ddda010799cd2fd0e7e1529ed03e49ee867dd0834042c640fa4c1c72839"
    sha256 ventura:        "edaff9c715de640257e84bb4527d920684c3b6e96cd1a53e069702bd3439ee1e"
    sha256 monterey:       "f693093c29dfabc72781914f1c77ca937680d6c7856c19ceea4fd5ee4af9a597"
    sha256 big_sur:        "53a6ab8d88240c1ac337495f0a9ad7d5075126d2c60291fa7a0101bde82fedfb"
    sha256 x86_64_linux:   "f5135d3c388604b570fba3049d8542e5e62ada0c0d341dbd7c3e0bd91b809929"
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
