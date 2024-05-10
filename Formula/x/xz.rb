class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.6.tar.gz"
  mirror "https://archive.org/download/xz-5.4.6/xz-5.4.6.tar.gz"
  mirror "http://archive.org/download/xz-5.4.6/xz-5.4.6.tar.gz"
  sha256 "aeba3e03bf8140ddedf62a0a367158340520f6b384f75ca6045ccc6c0d43fd5c"
  license all_of: [
    :public_domain,
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01ced87d92d0c1131c069108efb14f6940f9e528e2d044ac41d9a0d8f5169f2e"
    sha256 cellar: :any,                 arm64_ventura:  "baba463d36447d4c858e51dfac347792eb65216e21eedab7b98fe79793335f28"
    sha256 cellar: :any,                 arm64_monterey: "d7a51a59ce7e63b9e3f81be7f3b239d951ac83ab429a7c4423ba14c064ec7921"
    sha256 cellar: :any,                 sonoma:         "139fcf6d46fb85d3693f5d7452a37ec5f50f17b5ef044ac96a2c7deccb7983b4"
    sha256 cellar: :any,                 ventura:        "8a3f7325f367f90a22f3c17c0bcc65af615de713a8598e973691e84f118b325c"
    sha256 cellar: :any,                 monterey:       "9195af5a2fcbecf42267f4738254a3a58257d2a303fa6c63ec09eb4def7f7c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0736983b952c5273bb5a345008bac7311c2f4b60758d69cc05495d5b050f88f1"
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
