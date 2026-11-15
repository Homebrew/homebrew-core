class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://github.com/tukaani-project/xz/releases/download/v5.8.4/xz-5.8.4.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lzmautils/xz-5.8.4.tar.gz"
  mirror "http://downloads.sourceforge.net/project/lzmautils/xz-5.8.4.tar.gz"
  sha256 "0014c7886930454fe8bd4228665b51af55eeae560ea135c9c4cd33f55b2591d9"
  license all_of: [
    "0BSD",
    "GPL-2.0-or-later",
  ]
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2b5d6523153be05c20bcc51cd358ea3dd1f4bf893748fdedb779ab508ea63ce"
    sha256 cellar: :any, arm64_tahoe:       "d291ad2277682238329b0e4d249e5e2c948c4b10cd64dba1963d897330ad88dd"
    sha256 cellar: :any, arm64_sequoia:     "c2724c0db0398134694b8366d30d14f4de376115fb54c559c331d5fd0474af76"
    sha256 cellar: :any, arm64_linux:       "fd4f4c75678cc31e474931ff9798f0ca9aeb137b401faec2f6339891f2b40f94"
    sha256 cellar: :any, x86_64_linux:      "aa3b18af4d682e52746cd73dca60cec5422bfe1dc8bf4fff3c38a63fe4d516f5"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", "--disable-nls", *std_configure_args
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
  end
end
