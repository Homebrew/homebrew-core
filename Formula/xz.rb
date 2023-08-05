# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.4.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.4.tar.gz"
  mirror "https://archive.org/download/xz-5.4.4/xz-5.4.4.tar.gz"
  mirror "http://archive.org/download/xz-5.4.4/xz-5.4.4.tar.gz"
  sha256 "aae39544e254cfd27e942d35a048d592959bd7a79f9a624afb0498bb5613bdf8"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ba318d89eea54f33cc3613b1cb69ca4217a8f961e59026418e569e8421afbb8c"
    sha256 cellar: :any, arm64_monterey: "c8a9e7812c258a3b5043c0207b8044ba099a0a4a97d3ab5314a0dbd171fff3f4"
    sha256 cellar: :any, arm64_big_sur:  "1857edbbd38cff88854e529670e708e6d87e9d01641e291efee79cafa82fe5b2"
    sha256 cellar: :any, ventura:        "4c25f68798c0b4c9b869e78fdfbd9cd7f8f723c51ea56d643b5644456288d69e"
    sha256 cellar: :any, monterey:       "39a76706744e6f78f883c38e800d277bc6df71186313cc5fa362072d6c79f991"
    sha256 cellar: :any, big_sur:        "7bc66bbf17c331e226b65947a7b2c326a883bc70ccdd13127802612713ae1cc2"
    sha256               x86_64_linux:   "f68637417bc856ba59f1ec25f7fcb0ccba14a9d53557837dcf2ab0ddb652fb8b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
