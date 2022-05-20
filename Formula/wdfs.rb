class Wdfs < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, catalina:    "a00329ad59065dc12983272eb1da0e861aa73cbfa8b2edc69393a5a2eba4e49f"
    sha256 cellar: :any, mojave:      "edf41371511f947ef47c0ad7575cffb5831687c975f000f51e538133ec42563f"
    sha256 cellar: :any, high_sierra: "f2f3ad809ea9104bb5fd49b4f903b0465707baf76be3329422ea34aeed8bacb4"
    sha256 cellar: :any, sierra:      "7aab5f9c3d807f73dfe9df437a15806b74bc5a76cd3cd13e961ea781c7fa32fb"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "neon"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system "#{bin}/wdfs", "-v"
  end
end
