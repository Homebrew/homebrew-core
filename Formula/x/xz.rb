class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://github.com/tukaani-project/xz/releases/download/v5.8.3/xz-5.8.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.8.3.tar.gz"
  mirror "http://downloads.sourceforge.net/project/lzmautils/xz-5.8.3.tar.gz"
  sha256 "3d3a1b973af218114f4f889bbaa2f4c037deaae0c8e815eec381c3d546b974a0"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55c891f5d47142fe923c87df0e3343d7ef2bc7d368c67892b4ad2c80e53069d5"
    sha256 cellar: :any,                 arm64_sequoia: "c4be907ac8459f8b3e764c06287cc88b79c1d5c16a2db1c0335e1facf4fd4dbe"
    sha256 cellar: :any,                 arm64_sonoma:  "0a6e40dbeea3358a1277f347ef9b892070096a79a81cda90edfedbfe721c4ba3"
    sha256 cellar: :any,                 tahoe:         "df5011c2bf8ce426cd62fcd0b849268511cfdbf71331f7eaa07bf790bcf93a0f"
    sha256 cellar: :any,                 sequoia:       "be9bd234f1e9ec28b25cd8ce0850ea841751cd337dffd6f104432c57cdc32c78"
    sha256 cellar: :any,                 sonoma:        "fcd2df6962b5b94ef14232d02df71ee0b329482c2d8478942e07287f016ebe73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d983dde14681d8403f46f7fc1a5b743b98b0fa84e3cf4b07153709847a71f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61032fd340234974371a87c9908c998d9a52bebdf056b83e629ebf7aa038840f"
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
