class Sc68 < Formula
  desc "Play music originally designed for Atari ST and Amiga computers"
  homepage "https://sc68.atari.org/project.html"
  url "https://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz"
  sha256 "d7371f0f406dc925debf50f64df1f0700e1d29a8502bb170883fc41cc733265f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/sc68[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "53d85d767390195f2981d328f9454b5df20000eedb86dba469cb3c2283f44362"
    sha256 arm64_sequoia: "4b0cd49f4b77db5e2de07e8aff83a53f15f14f4e7a28586586211f2e6684fbf8"
    sha256 arm64_sonoma:  "2a2374981d613d8e2bb05b955db6910030262245d1b869ba473752cdb4eb78b2"
    sha256 sonoma:        "ac28932ddb06977f5433011fc5ccb445f8e224e04450937c526d87602fd75e3e"
    sha256 arm64_linux:   "e84036f32f6d2611c303b5a94a6dfded890325f32be9136a29a1cb6f07bc7bf2"
    sha256 x86_64_linux:  "a0a017e21ee44eb366f596f25060e63bff20d4b591845b6e933dddf6eda65c8c"
  end

  head do
    url "https://svn.code.sf.net/p/sc68/code/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    if build.head?
      system "tools/svn-bootstrap.sh"
    else
      inreplace "configure", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      # Workaround for newer Clang
      odie "Try to remove workaround for Xcode 16 Clang!" if version > "2.2.1"
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500
    end

    args = ["--mandir=#{man}", "--infodir=#{info}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # SC68 ships with a sample module; test attempts to print its metadata
    system bin/"info68", pkgshare/"Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
