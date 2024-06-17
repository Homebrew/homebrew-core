class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.03.tar.bz2"
    sha256 "e0a091cdbd5a11d314f48526212ba34cdb71bbdf5622dfc1f28aa6291c93ede8"

    # release tag request, https://gitlab.com/hors/libzakalwe/-/issues/1
    resource "libzakalwe" do
      url "https://gitlab.com/hors/libzakalwe.git",
        revision: "521bc3ba81d78859fb3cabae88dae6ebe41f9c03"
    end

    # release tag request, https://gitlab.com/heikkiorsila/bencodetools/-/issues/13
    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git",
        revision: "ffde760bcb83182f6a4994f585773d5af264601d"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ca6ab0d34ad18f7f1af0024fe14cb9cd6bef936ef02f3d77eef3d5fa369eaf58"
    sha256 arm64_ventura:  "ff3b1f1c5f687a21cd58cf8b27a057dde20cc10f416bc88dcf0397c58f9bbbe0"
    sha256 arm64_monterey: "9af83e4001e9d24b2fc574e0c878e7d4d30df953cb343d5538cc3cb4b8487daa"
    sha256 arm64_big_sur:  "ce39bfc4de99db6404766c3922d6592bdba45c1149dea31561a87561bfc247f1"
    sha256 sonoma:         "5f3a536ef40fb4f7210c907e27af3422126cf2c364ab542cf2b3bac7c6221ebe"
    sha256 ventura:        "666c380c57fe9e14b2f3852de79e8c77933300fbcf636d1cd20abec84c3cd7e3"
    sha256 monterey:       "d8892c99c748919747c3b80898256647642ebad0078aed6c9f3db7bce2693561"
    sha256 big_sur:        "ccfc305a99a2b9e01ea0e61e2d9d90494822da2029411e19a7c8b9e0adb24bc6"
    sha256 x86_64_linux:   "6a5220023b7fb15a23f57a52f7c73c42e547264ee0682177f612046f907519ab"
  end

  head do
    url "https://gitlab.com/uade-music-player/uade.git", branch: "master"

    resource "libzakalwe" do
      url "https://gitlab.com/hors/libzakalwe.git", branch: "master"
    end

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", branch: "master"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libao"

  def install
    lib.mkdir # for libzakalwe

    resource("libzakalwe").stage do
      # Workaround for Xcode 14.3
      if DevelopmentTools.clang_build_version >= 1403
        inreplace "Makefile", "CFLAGS = -W -Wall", "CFLAGS = -Wno-implicit-function-declaration -W -Wall"
      end

      inreplace "Makefile", "-Wl,-soname,$@", "-Wl"
      system "./configure", *std_configure_args
      system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    end

    resource("bencode-tools").stage do
      system "./configure", "--prefix=#{prefix}", "--without-python"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--libzakalwe-prefix=#{prefix}",
                          "--without-write-audio"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/uade123 --get-info #{test_fixtures("test.mp3")} 2>&1", 1).chomp
    assert_equal "Unknown format: #{test_fixtures("test.mp3")}", output

    assert_match version.to_s, shell_output("#{bin}/uade123 --version")
  end
end
