class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.10.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.10.1.tar.lz"
  sha256 "43ddfe10724a8b85e2468f6403b6000737186f01e60e0bd62fde69d842234cc5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9cf6ea9614d1286230615b81443f0941b32cd7768769378039df8463d71fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579a458898062f0b99c455e69e93cbf4c2b5637ae72806d4ee74f4063f2a25ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b241d433eecdd7d01df54bafa597df65a42ad75866ece0a16d865a205c0660b1"
    sha256 cellar: :any_skip_relocation, ventura:        "92020e945f2e80c82762fc8153a95223d040ed5024a4a93f396fc26195787d65"
    sha256 cellar: :any_skip_relocation, monterey:       "816051fa12300cd95e60babba5d4613e47f4c0c6fb426d520edf1f04914b91c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf4c810451ae3f5d2fe9ee983bce3c3d21573125bf55375a27e0dd7a7ff461f6"
    sha256 cellar: :any_skip_relocation, catalina:       "46b57c5880786bbebf8e776acf35f6b95adb29cdda2198bf2abf6258a4367c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd4d79803732fe588d5cacf620d6e9216002d5d93acf6f0798a225174e2db28"
  end

  uses_from_macos "ed" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
