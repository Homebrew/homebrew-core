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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5de19727020b72e3d9aca5b82ac379f7e28262e02ed3baf78a75325d99286d48"
    sha256 cellar: :any,                 arm64_ventura:  "f4b2dfaa60525765aae78c823f600ab9bff4232798e4f3e0d984d8056b27f420"
    sha256 cellar: :any,                 arm64_monterey: "ba29b23ec8749e31962a3850dde2465cf0006ff58846b35824f513916304ee1d"
    sha256 cellar: :any,                 sonoma:         "35628316edd14ff77eefb6cdcdfc1d97ddfdd2bac32ff60370abeefe3a4796f9"
    sha256 cellar: :any,                 ventura:        "fdf1c431c6b921abdc3c1b89f1fa93821599c040707554fc1a17ea8ef9aeaadf"
    sha256 cellar: :any,                 monterey:       "628a41a2ce6328656b82c27801842159e4f879545427e52c44c8b8345fd9425c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e4a4c53b09215de7125acfdf7f1a6078eadc2a942b64f475c5c1c574f72f9e"
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
