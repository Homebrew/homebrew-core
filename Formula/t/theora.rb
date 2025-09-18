class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.2.0.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/theora/libtheora-1.2.0.tar.gz"
  sha256 "279327339903b544c28a92aeada7d0dcfd0397b59c2f368cc698ac56f515906e"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/theora/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libtheora[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b611f6607b0d916bd49ec4b88113cd230d7c0199865b287e75b1ae769bae64b0"
    sha256 cellar: :any,                 arm64_sequoia: "0474983a6d3f2982c2b34586f12c58d5363ed4e67e6642686d295a4c62533d6e"
    sha256 cellar: :any,                 arm64_sonoma:  "878dc139277240e36ce8c46ed65d869f16fc3386d1f1f89206f897a1a96b199b"
    sha256 cellar: :any,                 arm64_ventura: "38881010b87d59c0e6fc985c48dd607a3a78f18f58ae6a91ba17d0f80bb89a5b"
    sha256 cellar: :any,                 sonoma:        "094215d640402c7f3730447fa4dcc8335cfbc92f759bb426335fc2ba08feaf1f"
    sha256 cellar: :any,                 ventura:       "7b1efa69f2e6a7efbbd0bbe5b5127992816b2d680980ea4cf8c3d8050bca3cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54226528eb3fc0bad9b016d49bec5b58ce076253a256dddb19e5c18829948c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ef196a720cc37055ba91062862548c6325398fefe3e94ea3b540f8db8eb4c7"
  end

  head do
    url "https://gitlab.xiph.org/xiph/theora.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    system "./autogen.sh" if build.head?

    args = %w[
      --disable-oggtest
      --disable-vorbistest
      --disable-examples
    ]
    args << "--disable-asm" if build.head?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <theora/theora.h>

      int main()
      {
          theora_info inf;
          theora_info_init(&inf);
          theora_info_clear(&inf);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltheora", "-o", "test"
    system "./test"
  end
end
