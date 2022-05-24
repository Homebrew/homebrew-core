class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/76153/yash-2.52.tar.xz"
  sha256 "55137beffd83848805b8cef90c0c6af540744afcc103e1b0f7bdf3ef1991b5c9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://osdn.net/projects/yash/releases/rss"
    regex(%r{(\d+(?:\.\d+)+)</title>}i)
  end

  bottle do
    sha256 arm64_monterey: "39193d5400fb287f3dc7706f966338e68b9738f0f4a30fab43179d373e6c7eeb"
    sha256 arm64_big_sur:  "d929857c2f1cfd3f343005126fbe77e36bf03913f9425fcad54f5cbc5791d7d2"
    sha256 monterey:       "0a7dc67022f949b2fc299cafa6ea02e984ad62c23e6cfc554610b41f4fdca0fb"
    sha256 big_sur:        "f2f03214717748a4b41acbf588b4bee409dff6c9b20f3e260b250d9a431b589d"
    sha256 catalina:       "b7340fc1cdd7eff266bd06cf15cee55e6ef6fb99dcd140213e03fdd98ae44819"
    sha256 mojave:         "7558ff13a140aad05b09bc15622e822489f9d86b2c75bcae68ad6899e3111136"
    sha256 x86_64_linux:   "48947c3a32a0d69ace5b0d40d2e037da21f2825aa1d5fab780b0e46ab01d4083"
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
