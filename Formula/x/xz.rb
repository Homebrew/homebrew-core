class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://github.com/tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.6.4.tar.gz"
  mirror "http://downloads.sourceforge.net/project/lzmautils/xz-5.6.4.tar.gz"
  sha256 "269e3f2e512cbd3314849982014dc199a7b2148cf5c91cedc6db629acdf5e09b"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b49f3559f9425b0a8c8de8806b2162d757196c06d4043e65c6654e88cdac15e0"
    sha256 cellar: :any,                 arm64_sonoma:  "928cd470a16d10f9c8d444336314101e7b524f9aa5aeaa108569982c2bd83a63"
    sha256 cellar: :any,                 arm64_ventura: "47bd10fdb1173d54ce37deea250eef4a1a05f45420422d824bf43efea13c28f6"
    sha256 cellar: :any,                 sequoia:       "6ad8909a81ad8f4d8e6f9e08c2bba861ca213293184f37246d1687afe554cc40"
    sha256 cellar: :any,                 sonoma:        "5d81f474f98ede15215878db75db8359b154ae17a4710c1d0dd1534c5fda451c"
    sha256 cellar: :any,                 ventura:       "6e91c631057824a93598109c8fed9eae289ea8118db9c4204d5c334647982892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c40857ccdacee0eaf8a19a2851f9e4389443da7c10cd6cf50e9c1ef56872c59c"
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
