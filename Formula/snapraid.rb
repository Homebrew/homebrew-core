class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.1/snapraid-12.1.tar.gz"
  sha256 "49337d9bafa96c2beac0125463bd22622be2fc00f3b4dee7e4b0e864d2a49661"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d20ff8503539841556e21e7d0057cdb1809afe6e567cacd06ae3836dd926d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b41c49eda71535ffc7564251e70a820f4b0513a74a23c55b9d8aa1523e98068f"
    sha256 cellar: :any_skip_relocation, monterey:       "5efccbd9f6296b4d1837b3dac308377c05231d7006584dde4e2463429c6bbb59"
    sha256 cellar: :any_skip_relocation, big_sur:        "edb9c4dda5b01601fb93e40135f0b1edb664312724296dbc8352a804d4cd3fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "f81957dda823e5dc23653d0a2e97a482bd29b1f7adf216a8f519666891c0af5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11d0d850842991e846c4bc0db7de38f664040ad5eef4bf76c3b7fdeac9709c79"
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
