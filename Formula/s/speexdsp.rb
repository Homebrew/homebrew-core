class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://speex.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/speex/speexdsp-1.2.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/speex/speexdsp-1.2.1.tar.gz"
  sha256 "8c777343e4a6399569c72abc38a95b24db56882c83dbdb6c6424a5f4aeb54d3d"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/speex/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)speexdsp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e7647620836f6c58957deb0c5994b29b087c0574b5feca71fbaa9dd67d15a092"
    sha256 cellar: :any,                 arm64_sequoia:  "c19e5962197be02c5124dc4c2cef39ef6a6b00bddb5f3cb7dca9c3e31929d086"
    sha256 cellar: :any,                 arm64_sonoma:   "ff689f3f675047fd194a585d0a08a204f0bbd0026b0d67694be5b1b2fe08980d"
    sha256 cellar: :any,                 arm64_ventura:  "c794738735292d75e590ba371e29ac57fdfc465f712dd20823634a310759e824"
    sha256 cellar: :any,                 arm64_monterey: "f43bb5f238f0c3b74a4b08c09d4cc98c8935e77024f3c2e109b2683e5197f18c"
    sha256 cellar: :any,                 arm64_big_sur:  "78f624d4cb561115ca94e9caa71dc45f2b4227eb443245b7ae07674fb54bd81b"
    sha256 cellar: :any,                 sonoma:         "d36e29b66b65a4d81e246d825187877ef05f47325bf032948c8bc4cddb826613"
    sha256 cellar: :any,                 ventura:        "f4dfeb2d0eaf57c871269de74f64df8ca82acfb72a1a81fd24698ab0309f3321"
    sha256 cellar: :any,                 monterey:       "b4d9cbbd5ad3e85630759fe8183c61fa94d772888c62f9a819b11b32ed1b7664"
    sha256 cellar: :any,                 big_sur:        "58d8bf8055672d3d7192c74a6381109c03507ea2ac11c0b1e40fd6b29c288415"
    sha256 cellar: :any,                 catalina:       "3499528f9bfb7c9a1bdff9d1da7f3de4c3dc5d54d25693e156592e76dec5f1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e4f60d49f781e99446057cfcee58ac1ebc00f3d003d377a8615b662b56a5b9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c417e96a3739f41fb59aca0ceba32fd45b07f79175d8eda837dd125159098453"
  end

  head do
    url "https://gitlab.xiph.org/xiph/speexdsp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <speex/speex_resampler.h>
      #include <stdlib.h>

      int main()
      {
          SpeexResamplerState *st = speex_resampler_init(1, 8000, 12000, 10, NULL);
          speex_resampler_set_rate(st, 96000, 44100);
          speex_resampler_skip_zeros(st);
          speex_resampler_destroy(st);

          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lspeexdsp", "-o", "test"
    system "./test"
  end
end
