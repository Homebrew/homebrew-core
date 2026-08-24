class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftpmirror.gnu.org/gnu/wdiff/wdiff-1.2.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.3.tar.gz"
  sha256 "29a4457eb0ed35c902e6732d71f25e1d6c7fe7fa0eda0fb6c371ed6779b49fd6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "ce4adeb51852e112fe76a73a1c38062eda8608965e06ca78023874b9f59b79bb"
    sha256 arm64_sequoia: "a460deb2bef54642d0647be807c43bf61d5a2b00435d7f69a6b9323ae5c6822f"
    sha256 arm64_sonoma:  "050fc462e265dc4f4a7667da9f960572c23f11fa216aec7d56029f4c1dc28f42"
    sha256 sonoma:        "ac86b29de6c7b00d828b0e92d6970b3dd46a55dfeda235bbf16dfc38889dd9fc"
    sha256 arm64_linux:   "8ae98c718e5cc91349d73b53268f4b9c1b783269d26070a97b634aaf46500e26"
    sha256 x86_64_linux:  "40606235c83e71f751aaa0ee2054e79e2891260b6fbfdd16f6c3088e79b36ec8"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  conflicts_with "montage", because: "both install an `mdiff` executable"

  def install
    system "./configure", "--enable-experimental", *std_configure_args
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
