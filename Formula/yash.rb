class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/78345/yash-2.54.tar.xz"
  sha256 "44a0ac1ccf7c3acecfbea027d8c0c930f13a828065be318055ce113015391839"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://osdn.net/projects/yash/releases/rss"
    regex(%r{(\d+(?:\.\d+)+)</title>}i)
  end

  bottle do
    sha256 arm64_ventura:  "825e7b433ab67cedb8bda81d53a97daa4d3193735121f661a2133631c0d8950c"
    sha256 arm64_monterey: "a8a728c98a8656d570ee6a635cb964a3c9201677c4ebe23f6c8f77a0e71ae45d"
    sha256 arm64_big_sur:  "d9ac37ee67f2c7bcdd66438a9543c3cd07b7b2ecdeb1bf8bf9c0acdae9b002d3"
    sha256 ventura:        "88eb309f518d95d2c73ff4871f7eff9c6dbe05e2a2860bd237d19dbcbcd1ebd6"
    sha256 monterey:       "4ab2ebd75246a927c5e2ac95566ae5848ed0bbfd602eecbcb6bec2fe0ef294eb"
    sha256 big_sur:        "fb27779593e6243c326a630dfbd892ae65de86118e10f60a0fb6baa5108db05b"
    sha256 x86_64_linux:   "be69b88316019ac27d2b9e8f9583748c7640faa72dbc0816589d2330029553b5"
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
