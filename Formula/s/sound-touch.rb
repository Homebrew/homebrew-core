class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.4.1.tar.gz"
  sha256 "e07abf20ce8f95850c280132e1f61ad400fc1f4011b7fac698a503de6aab6733"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39c7a9f7b42d7eceab47adbe2dd62a299a2bc6696cde16e8bfefbe13048407ce"
    sha256 cellar: :any,                 arm64_sequoia: "e3c88c3e3f09f770a320d5bcbc66deab58b7aadb7f45903ab44656e7f8dcc23c"
    sha256 cellar: :any,                 arm64_sonoma:  "b748642ae9a1df505261660b2d40836d9d072f8350820a5b8a456c3ebf9ef7c3"
    sha256 cellar: :any,                 sonoma:        "a98b143aff369357b87c07197525e221f461b62af1bce6ebcf31a55827b93533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b61df500d6bf34c8a0cf7f443c19f7373479b5f90f7428345bdd113cf8d8ec6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8516cc0bf2c85ede1f7cb438287a1e1ba936001aeda358ef2f2a03ab3847d6db"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "CXXFLAGS", "-std=c++14"

    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "SoundStretch v#{version} -", shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
