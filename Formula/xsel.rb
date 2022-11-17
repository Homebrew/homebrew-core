class Xsel < Formula
  desc "Command-line program for getting and setting the contents of the X selection"
  homepage "http://www.vergenet.net/~conrad/software/xsel/"
  license "MIT"

  # Stable block to apply Fedora patches as current release is from 2008.
  # Remove when a new release is available.
  stable do
    url "http://www.vergenet.net/~conrad/software/xsel/download/xsel-1.2.0.tar.gz"
    sha256 "b927ce08dc82f4c30140223959b90cf65e1076f000ce95e520419ec32f5b141c"

    # Fedora Patch 0: xsel-1.2.0-MAX_NUM_TARGETS.patch (using upstream commit)
    # Fix overflow of supported_targets array.
    patch do
      url "https://github.com/kfish/xsel/commit/26b2bf93ef72b2e53dac5a97de8551bbfcf22e80.patch?full_index=1"
      sha256 "1c40e4f282e1e5632f989937e993c6a331c4b84cb061798e9d77495c3e3a2803"
    end

    # Fedora Patch 1: xsel-1.2.0-fix-large-pastes.patch (using upstream commits)
    # Fix xsel not working when pasting large amounts of text.
    patch do
      url "https://github.com/kfish/xsel/commit/ba8656dc7c7e771c802fc957ce3dd128d4b6e3ae.patch?full_index=1"
      sha256 "9cddda04d7b56d0fd95ddd9bc3d9cbd8a9682a151c0fb29493505d6fba12544f"
    end

    patch do
      url "https://github.com/kfish/xsel/commit/5c95883fc06e3a98e51d02a9158f4009b75c724e.patch?full_index=1"
      sha256 "27b3fa207c79c211ea2f6d6b034cab38aa11cb9872b32cba8f0b18b3cc874bb8"
    end

    # Fedora Patch 2: xsel-1.2.0-fix-java-pasting.patch (using upstream commit)
    # Fix to make xsel compatible with Java programs.
    patch do
      url "https://github.com/kfish/xsel/commit/9674445d8ea9f60f4d1a154be6fdb12e7af8f0c6.patch?full_index=1"
      sha256 "4c2d63c2237805cd3fe59e0daac59d0033574d3f664081f6af5fb71b8e688b44"
    end

    # Fedora Patch 3: xsel-1.2.0-do-not-terminate-string.patch
    # Backport of https://github.com/kfish/xsel/pull/16
    patch do
      url "https://src.fedoraproject.org/rpms/xsel/raw/6a957e9ee81b29c593124336be000b05eaa3d537/f/xsel-1.2.0-do-not-terminate-string.patch"
      sha256 "48f61ed4994bfb2e1691c7af92fb5364d2da8217fc7b01bf8ee63c3f3a81ddf3"
    end

    # Fedora Patch 4: xsel-1.2.0-send-correct-event.patch
    # Backport of https://github.com/kfish/xsel/pull/16
    patch do
      url "https://src.fedoraproject.org/rpms/xsel/raw/6a957e9ee81b29c593124336be000b05eaa3d537/f/xsel-1.2.0-send-correct-event.patch"
      sha256 "d71fe4a979f41cab51c580dd2f83ee1da0ae3408f18769cc5f5eaf5654d3744f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30abd9f1f7e2ff38f890f01f3c7919a9fcad59ada8c530b933583421cfcf6232"
    sha256 cellar: :any,                 arm64_monterey: "de069e6eb3b7f2ab28641b1be7c7df88a0ea59587e01e59b79ddc680e0226194"
    sha256 cellar: :any,                 arm64_big_sur:  "b32e829803d81ea7d09bb0911b31a20ac6c75fdbc67fa3c4c9184458e3d3ecb3"
    sha256 cellar: :any,                 ventura:        "358506ddb783e7b8ede9380e03c66bfc70d6d2846e5f5a10411d9eac286c55cd"
    sha256 cellar: :any,                 monterey:       "834b49b7669f077df30e1e791037b5ebabc657aef2d9b1c6c4c8425b8c401754"
    sha256 cellar: :any,                 big_sur:        "f596d08cffadf2bff12804cc18fc61ddb4cdf47599f869d938c7ebd860e1950d"
    sha256 cellar: :any,                 catalina:       "18f72e215611df386415475668dd769e37c6b715715e477ba39866f17a95c1f2"
    sha256 cellar: :any,                 mojave:         "8fd34073cf958d18b31d51f0e3d05f7a93e0a71b00cc696bdf4d4018409b3c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81062fbb7f2a56e6510ab0103c795e5f0091dafa810100d03a83b3295b3f577f"
  end

  head do
    url "https://github.com/kfish/xsel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libxt" => :build
  depends_on "libx11"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Usage: xsel [options]", shell_output("#{bin}/xsel --help")
    assert_match "xsel version #{version} ", shell_output("#{bin}/xsel --version")
    assert_match "xsel: Can't open display", shell_output("DISPLAY= #{bin}/xsel -o 2>&1", 1)
  end
end
