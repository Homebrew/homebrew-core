class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://github.com/tukaani-project/xz/releases/download/v5.8.2/xz-5.8.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.8.2.tar.gz"
  mirror "http://downloads.sourceforge.net/project/lzmautils/xz-5.8.2.tar.gz"
  sha256 "ce09c50a5962786b83e5da389c90dd2c15ecd0980a258dd01f70f9e7ce58a8f1"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "770e7bbcac1c6422435e63cdc48fc68f40942060913ee2d8d24d4a0eadbeb593"
    sha256 cellar: :any,                 arm64_sequoia: "d0ec2004d93c33f1077eefdd2831075b010b1f8e4f58a7e72b02b7f39cf037a0"
    sha256 cellar: :any,                 arm64_sonoma:  "e50564d9d3449bc62d111977cc434c33f419f26c1a8befe1672c18b225f714ef"
    sha256 cellar: :any,                 tahoe:         "79be5da804bdae92c823d7056287c417af1089e52efa6ae443a7cd7c92165b09"
    sha256 cellar: :any,                 sequoia:       "7ed1dae7c8ba2d61bf2bc0db326c8235193c603e4421aac0fa7b64060ec10fa1"
    sha256 cellar: :any,                 sonoma:        "2f643a3897536c1baa1376f594f1aec987d1336c1980567d58bc5692ef895a04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7707181e84ba592d8e3930722ecb55e7978e32c70ea7b640d5c8e7578572c4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a4e124a1ec2f7435b6bd44f3e980fc6e90fec9e3a93b229f9432d73e664b65"
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
    refute_path_exists path

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read

    # Check that http mirror works
    xz_tar = testpath/"xz.tar.gz"
    stable.mirrors.each do |mirror|
      next if mirror.start_with?("https")

      xz_tar.unlink if xz_tar.exist?

      # Set fake CA Cert to block any HTTPS redirects.
      system "curl", "--location", mirror, "--cacert", "/fake", "--output", xz_tar
      assert_equal stable.checksum.hexdigest, xz_tar.sha256
    end
  end
end
