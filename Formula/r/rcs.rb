class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftpmirror.gnu.org/gnu/rcs/rcs-5.10.1.tar.lz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.10.1.tar.lz"
  sha256 "43ddfe10724a8b85e2468f6403b6000737186f01e60e0bd62fde69d842234cc5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "300e27fe13d2279ed6fa2fd5d06fdf4369311b86818229df6285086e8a46cb52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec09df25d02575ef0506a90cc81def4001a17eb02fce6adf9933b6e359541282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "538f4c9f1747041c737c8c57f49ca2becc2cca7cd0c31f88cf14142d5d00c873"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9cf6ea9614d1286230615b81443f0941b32cd7768769378039df8463d71fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579a458898062f0b99c455e69e93cbf4c2b5637ae72806d4ee74f4063f2a25ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b241d433eecdd7d01df54bafa597df65a42ad75866ece0a16d865a205c0660b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bf006b8c2137100fd45092c3465ff9a3938e5f864a3c4e8186ca70d922f1d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "92020e945f2e80c82762fc8153a95223d040ed5024a4a93f396fc26195787d65"
    sha256 cellar: :any_skip_relocation, monterey:       "816051fa12300cd95e60babba5d4613e47f4c0c6fb426d520edf1f04914b91c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf4c810451ae3f5d2fe9ee983bce3c3d21573125bf55375a27e0dd7a7ff461f6"
    sha256 cellar: :any_skip_relocation, catalina:       "46b57c5880786bbebf8e776acf35f6b95adb29cdda2198bf2abf6258a4367c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ef51614aa19bd0fb8b3cd13203c4281f15ded280b2072023dbb7d2e003f6ef4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd4d79803732fe588d5cacf620d6e9216002d5d93acf6f0798a225174e2db28"
  end

  uses_from_macos "ed" => :build

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
