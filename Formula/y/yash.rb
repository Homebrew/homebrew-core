class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://magicant.github.io/yash/"
  url "https://github.com/magicant/yash/releases/download/2.58.1/yash-2.58.1.tar.xz"
  sha256 "7674ece98dc77bcc753db49c4311c30532f981682205f9047f20213a3a6755bb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "225741eb8fbdb9e8d8d15641fe12e222aea819c9128016e50bc3a1de9c3ed942"
    sha256 arm64_sonoma:  "5c0f1b84ae52d14b5ed0f37c327fdbcdd1f83efc2fec2e4b921a046a601a9d3e"
    sha256 arm64_ventura: "5cc35eb53ea7858696f8fd8840938b44557108cdc470992b22b44512392af10a"
    sha256 sonoma:        "5032275245e9f6c97ec3627cd86ddbc0f891f660cfc83a25bdff0820d6adfba7"
    sha256 ventura:       "ae453a1e123424f174d835a3d50af92490a4b480ffdc968395efe54fd30d82db"
    sha256 arm64_linux:   "f93e1510e25427961b0fb8cb302977ff7e3e5762cedbec7d3654c6f73c8885be"
    sha256 x86_64_linux:  "ee8f5b1b250186c56ba08df649cacc7471e009748a0e525cf1f83a68879476c3"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

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
