# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.5.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.5.tar.gz"
  mirror "https://archive.org/download/xz-5.4.5/xz-5.4.5.tar.gz"
  mirror "http://archive.org/download/xz-5.4.5/xz-5.4.5.tar.gz"
  sha256 "135c90b934aee8fbc0d467de87a05cb70d627da36abe518c357a873709e5b7d6"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ae2643e0e0013fa278b29d820bbf3a369f81cd14418928ca1f6c5ff080a793a0"
    sha256 cellar: :any,                 arm64_ventura:  "75ca7d81801e9c2573361a1aaa553ad031bf6dafd32f7725ffd2e18c1d1052b7"
    sha256 cellar: :any,                 arm64_monterey: "755d94d9a67b35d456b22fc14041e1c449aa9968fc4148df28b3a907f22e69ed"
    sha256 cellar: :any,                 sonoma:         "34c230d08268adb541b9c3344a9951bef3986a8982a344e615a4030a8b5246a0"
    sha256 cellar: :any,                 ventura:        "e4a4249283b10bd0ec256b3b526104949f9260d5cb2b3f8510553c39499f9e10"
    sha256 cellar: :any,                 monterey:       "41853ac4f5c5b722137371beb1d425ec9a1b0d3e57e3406abfe9ddaaab579c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36efdbf8c174303b09d082e7304d757ecb6019bf17073d4f9fe84953ec6cc3b"
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
