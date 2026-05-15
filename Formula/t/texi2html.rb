class Texi2html < Formula
  desc "Convert TeXinfo files to HTML"
  homepage "https://www.nongnu.org/texi2html/"
  url "https://download.savannah.gnu.org/releases/texi2html/texi2html-5.0.tar.gz"
  sha256 "e60edd2a9b8399ca615c6e81e06fa61946ba2f2406c76cd63eb829c91d3a3d7d"
  license "GPL-2.0-or-later"

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f76e24ff2903b5bc781b51c1fa641893343610b6827eed40af85063af2def71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2abbe20da6fd14b3e73a4d7f08f366af564a2dc2e86b39de3291a9f7c3b9eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2abbe20da6fd14b3e73a4d7f08f366af564a2dc2e86b39de3291a9f7c3b9eec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2abbe20da6fd14b3e73a4d7f08f366af564a2dc2e86b39de3291a9f7c3b9eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "20ac4a12f76ccf5fe1ab324264c9b72f1b3d9cfedf981b7e743b636045e32f45"
    sha256 cellar: :any_skip_relocation, ventura:       "20ac4a12f76ccf5fe1ab324264c9b72f1b3d9cfedf981b7e743b636045e32f45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07d313b8d6ff0b95101597fffdd363fe7a935154ed310c4ec4d47214339f6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec47e69ea0775ca07947f7be4d5111ab308b2b472042b517e0bf0ea19b115d05"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", "--infodir=#{info}", *args, *std_configure_args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system bin/"texi2html", "test.texinfo"
    assert_match "Hello World!", File.read("test.html")
  end
end
