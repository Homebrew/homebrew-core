class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftpmirror.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz"
  sha256 "51f74eb0f51cfa9873b85264dfdd5d46e8957ec95b88f0fb762f63d9e164c72e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "af864341784c9958f6ce991fa0e0bc3b5727dfc7c8f53a90cbf2339e080c2232"
    sha256 arm64_sequoia: "e26c8c7d0d1f5b68bb7e78e59f701838d45fa73e3ce768ab6b68e1a051ff751c"
    sha256 arm64_sonoma:  "6edceba78cb173242c77e481aa0adc88e6efbddf4e05239322d72f05b144b2bc"
    sha256 tahoe:         "0e80a4ba0a2a3a48eebb8078f1c79fe563e374c3c2ed77642901941fc42e015c"
    sha256 sequoia:       "93f14818e722ccc3152e9d2824095eb4ca79c58b37bc1ce58f0469a6e2735f21"
    sha256 sonoma:        "cf213ea4a3f93a42c4ad178e602e1eda6cf17dcf3c9fbeb024c4758910dc4878"
    sha256 arm64_linux:   "ae0c709a08d1e093bddc8c4c4f696592e38faed5c261d020f027dcf195425ddc"
    sha256 x86_64_linux:  "0dd622bb0151013803cdf5977f76cf78622fcb92478062d6ce2612199f7a049f"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    depends_on "libunistring"
  end

  def install
    system "./configure", "--disable-install-warnings", *std_configure_args
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  def post_install
    info_dir = HOMEBREW_PREFIX/"share/info/dir"
    info_dir.delete if info_dir.exist?
    info_dir.dirname.glob(["*.info", "*.info.gz"]) do |f|
      quiet_system("#{bin}/install-info", "--quiet", f, info_dir)
    end
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS

    system bin/"makeinfo", "test.texinfo"
    assert_match "Hello World!", (testpath/"test.info").read
  end
end
