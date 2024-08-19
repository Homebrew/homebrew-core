class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://github.com/tukaani-project/xz/releases/download/v5.6.2/xz-5.6.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.6.2.tar.gz"
  mirror "https://archive.org/download/xz-5.6.2.tar/xz-5.6.2.tar.gz"
  mirror "http://archive.org/download/xz-5.6.2.tar/xz-5.6.2.tar.gz"
  sha256 "8bfd20c0e1d86f0402f2497cfa71c6ab62d4cd35fd704276e3140bfb71414519"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ec389ac6a0b190914be00c62d2de0a18265c39d1243420d08841afea16ff7f9"
    sha256 cellar: :any,                 arm64_ventura:  "102957fe805b6182ed63b96ccf7eb027032867f318348b045a7b7cedf3534a2f"
    sha256 cellar: :any,                 arm64_monterey: "e45fcf2977a8541a97f7efef3ccbc0fc782c597b3c340616ada6868e7cf31452"
    sha256 cellar: :any,                 sonoma:         "b940be1e4e0492a9000c11ba2b23d4c57f0f9870c8535acfe149370a82bf73e4"
    sha256 cellar: :any,                 ventura:        "1f1b9f77e5e1938c2702db2834c0fa856d0134fa8ea14c1ab979dadda2952043"
    sha256 cellar: :any,                 monterey:       "4eb1665050b038767bf09f561882b5c9b51233d6738b81427e262deaac2b3c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab97999c22de61b2efa61c2a3f62d28085ce3f15601035955e41b8d783b89725"
  end

  deny_network_access! [:build, :postinstall]

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
