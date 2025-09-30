class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://github.com/tukaani-project/xz/releases/download/v5.8.1/xz-5.8.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.8.1.tar.gz"
  mirror "http://downloads.sourceforge.net/project/lzmautils/xz-5.8.1.tar.gz"
  sha256 "507825b599356c10dca1cd720c9d0d0c9d5400b9de300af00e4d1ea150795543"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9ee5b57b2c49e1a8e1c637f44adaf3632e5b3e79385326f93a162457b36d7b3"
    sha256 cellar: :any,                 arm64_sequoia: "dcd7823f2624cbcd08f55c232097a79300c7d76ab5969004db1a4785c6c0cd87"
    sha256 cellar: :any,                 arm64_sonoma:  "3bcdfeaa8b5bd910ac1cf1e7aec7e0fd82fd69f2f09c6ac682eca92725ad9e6c"
    sha256 cellar: :any,                 arm64_ventura: "82fef9b66eea967b55cd0f26fd7356d60a0b926c5d9eaaf9c300a46f21391af5"
    sha256 cellar: :any,                 tahoe:         "ce65e4c93e377bef7e6fc7df69689f157dc1bc4fcbda1c8108ace99b9e88970c"
    sha256 cellar: :any,                 sequoia:       "6558e19cb2f13893677ec1fe075d268a69ce242a064ce1dc53940234da4b2c5f"
    sha256 cellar: :any,                 sonoma:        "87c3638621021437d470c7f650336da533fa41222dfe54b94473bbea2acf6bbd"
    sha256 cellar: :any,                 ventura:       "c0aedd30a078e08c7e67107506c61348d8259a2dce40697b77ff76f8c0dfc6d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b246348ec4cc8643918e3c13b9f554e5ddede3d07e7e1c60eaba5b97120d473a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee1ff38fcc213fdefd262be65a06669f3e0118a2bd5fb387147ebe884f94413"
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
