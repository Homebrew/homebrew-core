class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://github.com/libxmp/xmp-cli/releases/download/xmp-4.2.0/xmp-4.2.0.tar.gz"
  sha256 "dc54513af9a4681029a1243fd0c9cdf153d813a1125de6c782926674285bc5ae"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "36e826302cd05a73582ffc6d1a196b64c71aa256069b9a605da25ab1692cb2d4"
    sha256 arm64_sequoia:  "656fb3759733a4e097ca973439b9ed791ddfeb768bbbe8203b9aa5684bb5883b"
    sha256 arm64_sonoma:   "95c30bbd87a818cdc81a4a90f27ba11585c5e11ddebfa5bc552e20246a4ab26c"
    sha256 arm64_ventura:  "0281add88058d565b3265efce120612e0602ba1b91b6a40f4334638917bb699f"
    sha256 arm64_monterey: "4701d7463ddc87e673d22631004939224605bb24c30b6054795d2844f514cabe"
    sha256 arm64_big_sur:  "3213693148aa35b597cdcc6ef098e3934663b37dc5beb1c88d3a5d65ebadac5e"
    sha256 sonoma:         "9ba602fd8dd7bf63d5aa794f5b3e265cca8b851107bae5db9dbb40396cb47eb8"
    sha256 ventura:        "f6b3bd880711583a9412817d663c83d05c64e70bde3fc17a20e050af70b9cb8c"
    sha256 monterey:       "151f11955e3f9db1c51ebde5e40ec1af12a3856ab50940f585983a3d59ff186f"
    sha256 big_sur:        "43193a0619e22f454184a1427ce8b306a22327b807f3f8d81fdb726357bc9842"
    sha256 arm64_linux:    "43d7f8abecadad5b2730da6399bce8db70e7f27289be34a5fc404afccfda33c5"
    sha256 x86_64_linux:   "bfa9f0f48823e7861c008d89c25cd43bdbe3553196b6684d15d962c8ca7087b4"
  end

  head do
    url "https://github.com/libxmp/xmp-cli.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Fast Tracker II", shell_output("#{bin}/xmp --list-formats")
    assert_match "Extended Module Player #{version}", shell_output("#{bin}/xmp --version")
  end
end
