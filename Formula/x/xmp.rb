class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://github.com/libxmp/xmp-cli/releases/download/xmp-4.3.1/xmp-4.3.1.tar.gz"
  sha256 "cbfdab11233708c4de6ab965f64d96d4cb5b9d8e14d2d23df3b1b896386f870f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "8a83641cb1f63efabdcb932c6bfea4c44915514af1186394dab92ee332154332"
    sha256 arm64_sequoia: "d8a40694abaf2eb15637f85c4faeb950867e74346070e44698dc449e4343ec95"
    sha256 arm64_sonoma:  "d8ed457bc7507cf37e7418cb679829a2510765f6484f38c2bc18498abb9955d9"
    sha256 sonoma:        "9834e4b17427595cf9fae5f015121de3495cf217241d952b7986d80a91277fba"
    sha256 arm64_linux:   "59b38e80194b5cbca5e8c440a7040d9692d333f1fe9b929fcd8c863272821776"
    sha256 x86_64_linux:  "bc3262ee98ef085100b01524a5ba46c205ab36cb05e04ccf88f04b7480230e61"
  end

  head do
    url "https://github.com/libxmp/xmp-cli.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Fast Tracker II", shell_output("#{bin}/xmp --list-formats")
    assert_match "Extended Module Player #{version}", shell_output("#{bin}/xmp --version")
  end
end
