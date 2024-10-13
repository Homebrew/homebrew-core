class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://github.com/tukaani-project/xz/releases/download/v5.6.3/xz-5.6.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.6.3.tar.gz"
  mirror "https://archive.org/download/xz-5.6.3.tar/xz-5.6.3.tar.gz"
  mirror "http://archive.org/download/xz-5.6.3.tar/xz-5.6.3.tar.gz"
  sha256 "b1d45295d3f71f25a4c9101bd7c8d16cb56348bbef3bbc738da0351e17c73317"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "743c3d366f11b139445c5a7c923ac937d825cd172e316e138f021a9156145fb0"
    sha256 cellar: :any,                 arm64_sonoma:  "c54997c6e29b576cf426815663aa21a3be2f7805d540e4a1da66cdcb834ae85f"
    sha256 cellar: :any,                 arm64_ventura: "1e04553da7c89433bb37ad67e9d75ff87e367d422ef5675a39f9b4e26644751e"
    sha256 cellar: :any,                 sonoma:        "0bed43466b3cbe8c8f7b307b31122d3ea9f18aa72c7e8ee82ce2bf40664d02d8"
    sha256 cellar: :any,                 ventura:       "25e2f54237603458eb5a06772eda87bc748e28f658d8e2e62a18412f06c0a724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360e9e63603136e0a4af1c9d0a6c28429fca9008fa5210cc12c2934117223c39"
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
