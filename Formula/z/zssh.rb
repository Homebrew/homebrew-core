class Zssh < Formula
  desc "Interactive file transfers over SSH"
  homepage "https://zssh.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/zssh/zssh/1.5/zssh-1.5c.tgz"
  sha256 "a2e840f82590690d27ea1ea1141af509ee34681fede897e58ae8d354701ce71b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/zssh[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf52245597c50c4d6d826e9be5a239ba19ac959c304ef69d75f9240092453128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f263234cd88fe188d247aaaf24e7d64e8cf990bbf671c0e98b96801710a3c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "762936295a2235c95c7a274daaf3e8b86c6154a2c17f272d852c3a951557f4de"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e88312f111f00dc479f90c1a317f7ceaa0aff00a6d6b7b24114a1952ceca529"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da32e62bd2610001f40c5e4e4ea30571f772a5198abebb78df5adbb8378218bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0550b13ce3b5a29c94c0124f03ac8dffbe76455395172d9b35b00f4c8328068"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "lrzsz"

  def install
    # Workaround for Xcode 15
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    rm_r "lrzsz-0.12.20"

    # NOTE: readline must be disabled as the license is incompatible with GPL-2.0-only,
    # https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility
    args = ["--disable-readline"] if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"

    bin.install "zssh", "ztelnet"
    man1.install "zssh.1", "ztelnet.1"
  end

  test do
    require "pty"
    PTY.spawn(bin/"zssh", "-V")
  end
end
