class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/74064/yash-2.51.tar.xz"
  sha256 "6f15e68eeb63fd42e91c3ce75eccf325f2c938fa1dc248e7213af37c043aeaf8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://osdn.net/projects/yash/releases/rss"
    regex(%r{(\d+(?:\.\d+)+)</title>}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "22128619892f2aa774cc6774c5041bcde2b711f0b3874455f565272c397d2503"
    sha256 big_sur:       "ff18cba8b4398b1ee3aa6542c27d0a925846d44ee25de4ffae836294024f8cea"
    sha256 catalina:      "a24fa6d8baa80ff63a770c93d15adef2f3d9fcb624fd6304aa16a763c20aab28"
    sha256 mojave:        "052617d9d5aab039e7e814b3d822e9c66ab4b9f3d8fd0c3b59cc5faf24e0ecd2"
    sha256 x86_64_linux:  "0c2bd891f0e9dcb39816e44db372e9508029c88dbc97552f82a672c3aa299a21"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  depends_on "gettext"

  def install
    system "sh", "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
