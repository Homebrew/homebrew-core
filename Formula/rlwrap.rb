class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.45.2.tar.gz"
  sha256 "7197559f193918cc8782421b5b1313abbde5e3b965a5f91f9ee25aee9b172ec5"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "2e026b8952dfc5806e289f72d741d03c3a53fa028a5aab2965b4b7793cdd1bf7"
    sha256 arm64_big_sur:  "d7f6b7527f6b090fe587c18ba314460a84949a81158399ff143521c2bf949e91"
    sha256 monterey:       "7a3f36bd7365d80d9182e1b1ff9f77177d9203c2358a36794fba1547dadc51fa"
    sha256 big_sur:        "4776bfe5bf3753463d331b150b37be72f4729aa144d9bb45030c56e9ad16c6a0"
    sha256 catalina:       "ca0fa52e2eb8649716938dd6d21a15652a7eeaf2ba0acfcb9cbd6cb9a5dae490"
    sha256 mojave:         "fcfe56a0eac619bcf9d9d1f8f5ddda648e09719c8c78c0db3d599f7edb7a59b7"
    sha256 x86_64_linux:   "525f35129e98623fbebda88c217862faf363bd9641d20858a9b8c14c120f4458"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rlwrap", "--version"
  end
end
