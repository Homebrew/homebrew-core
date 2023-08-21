class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  url "https://github.com/magicant/yash/releases/download/2.55/yash-2.55.tar.xz"
  sha256 "97cd809d5e216b3c4afae42379f1bd4f5082b7c16d51e282d60a5014fbc9e1f6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "90ea066abb125d0fdc4a43c1bb3a89bd6fd5ec90646d30ef39536d87f1d2d0aa"
    sha256 arm64_monterey: "dd0878a1d53e361e3427f7c5217802fa4bf76f589916bab12e43a50c67799e53"
    sha256 arm64_big_sur:  "5ecb266117d7cd02c3b7564e5a0f60909fb4e22a560c760e82c7b2a7a863fef5"
    sha256 ventura:        "00342c70f4a2c8ef6391b0e575623f23ed79691a19e0d30a625043c35a6fe1d6"
    sha256 monterey:       "a5418053156577c6d4d9d284470d9e0b8e597bbf143ad3f693230366601a1978"
    sha256 big_sur:        "c95be4b8c2ed56ad7cdcba185fa1dccef85309d03c2aa803fbda3ea551c87574"
    sha256 x86_64_linux:   "749b97b141717d11a41a45982d766c1ff1053afb91a438ccbcccafcd239b1aac"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  depends_on "gettext"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"yash", "-c", "echo hello world"
    assert_match version.to_s, shell_output("#{bin}/yash --version")
  end
end
