class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://xz.tukaani.org/xz-utils/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://github.com/tukaani-project/xz/releases/download/v5.6.1/xz-5.6.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.6.1.tar.gz"
  mirror "https://archive.org/download/xz-5.6.1.tar.gz/xz-5.6.1.tar.gz"
  mirror "http://archive.org/download/xz-5.6.1.tar.gz/xz-5.6.1.tar.gz"
  sha256 "2398f4a8e53345325f44bdd9f0cc7401bd9025d736c6d43b372f4dea77bf75b8"
  license all_of: [
    "0BSD",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5583c24107269a6223a3fae17d83b596d6ce1d84b3497be59670f143d73eaf7"
    sha256 cellar: :any,                 arm64_ventura:  "ba1734295f99d0090426b520e67f967e40b8b26ee5b258220d56014906c69606"
    sha256 cellar: :any,                 arm64_monterey: "0ae9c26448ce55dbc7604640826990ea630e74dfd084b430fa0c13805a58ae20"
    sha256 cellar: :any,                 sonoma:         "81c5be0ee64277bcee76ae2be974d82de050e815a266885f363b998a9c18117b"
    sha256 cellar: :any,                 ventura:        "2d778ef01a68e1ace220086a54df3a25f54673a7100603e710d64ed02b7f8353"
    sha256 cellar: :any,                 monterey:       "4e677b6b71dae40a67ad99fe3d174cff6aec27df234a22265411eb94df0f8fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca86f58b1cecdf378a756bb1e1bad590760b2442f848c1d10a1416d5c506e89f"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-nls"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    refute_predicate path, :exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read

    # Check that http mirror works
    xz_tar = testpath/"xz.tar.gz"
    stable.mirrors.each do |mirror|
      next if mirror.start_with?("https")

      xz_tar.unlink if xz_tar.exist?
      system "curl", "--location", mirror, "--output", xz_tar
      assert_equal stable.checksum.hexdigest, xz_tar.sha256
    end
  end
end
