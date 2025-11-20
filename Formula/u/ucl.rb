class Ucl < Formula
  desc "Data compression library with small memory footprint"
  homepage "https://www.oberhumer.com/opensource/ucl/"
  url "https://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz"
  sha256 "b865299ffd45d73412293369c9754b07637680e5c826915f097577cd27350348"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.oberhumer.com/opensource/ucl/download/"
    regex(/href=.*?ucl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "be21a9408fd10aabdb648f2c5075a234cd1308fd2628f6fb205751883835532f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2bf62c73925dcc1099836d528dd46f4f6f3fdae979f58584a930dbe92e89055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efc85c20038e401439abb0d3889816554d0476e968422782c97661a9b5c51ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "462fd1b3bf0382d5dd445f4d12b86f47e4577ab52a17d227b2c80a8e2faf5307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7f82e2d2c969d71a2dbaca2cc6c0f2577c422a16281a981e3193535263803c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef63a86669c63e486c3682494a93c9db453a33089a2a71398efb8e5e26cf5e44"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7e4f8a3757883ff1541ef0e571a38c72d3a1e74017c83d6ed3639559164f17a"
    sha256 cellar: :any_skip_relocation, ventura:        "395e6919528cb44ea1daecd6a41cc6e73da22f100e84310c67072b411ccd5db2"
    sha256 cellar: :any_skip_relocation, monterey:       "4317885999b8297a1919d5d65a9246efdd7bc1807fd2df4a9268a202fbf3a97c"
    sha256 cellar: :any_skip_relocation, big_sur:        "91ce0597dc8e648e4ee0d0caaa30bceb5f569acc90634d88fa5e7859f2ae682a"
    sha256 cellar: :any_skip_relocation, catalina:       "116db1f8157bf88831fece730fb3e6fa82420d53c29b032afd63b979df42b386"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b6a1eb60e36db3e3b262b7953d6523e61dc6cf519c06eb6487bdd2f7efda29bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1733761c7ce4452219f15055b4d72ca6e287c9c18691d9aa66c4aae0349d28c"
  end

  depends_on "automake" => :build

  def install
    # Workaround to build with newer GCC
    ENV.append "CFLAGS", "-std=c90" if OS.linux?

    # Workaround for ancient ./configure file
    # Normally it would be cleaner to run "autoremake" to get a more modern one,
    # but the tarball doesn't seem to include all of the local m4 files that were used
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    # Workaround for ancient config.sub files not recognising aarch64 macos.
    # As above, autoremake would be nicer, but that does not work.
    %w[config.guess config.sub].each do |fn|
      cp "#{Formula["automake"].opt_prefix}/share/automake-#{Formula["automake"].version.major_minor}/#{fn}",
         "acconfig/#{fn}"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      // simplified version of
      // https://github.com/korczis/ucl/blob/HEAD/examples/simple.c
      #include <stdio.h>
      #include <ucl/ucl.h>
      #include <ucl/uclconf.h>
      #define IN_LEN      (128*1024L)
      #define OUT_LEN     (IN_LEN + IN_LEN / 8 + 256)
      int main(int argc, char *argv[]) {
          int r;
          ucl_byte *in, *out;
          ucl_uint in_len, out_len, new_len;

          if (ucl_init() != UCL_E_OK) { return 4; }
          in = (ucl_byte *) ucl_malloc(IN_LEN);
          out = (ucl_byte *) ucl_malloc(OUT_LEN);
          if (in == NULL || out == NULL) { return 3; }

          in_len = IN_LEN;
          ucl_memset(in,0,in_len);

          r = ucl_nrv2b_99_compress(in,in_len,out,&out_len,NULL,5,NULL,NULL);
          if (r != UCL_E_OK) { return 2; }
          if (out_len >= in_len) { return 0; }
          r = ucl_nrv2b_decompress_8(out,out_len,in,&new_len,NULL);
          if (r != UCL_E_OK && new_len == in_len) { return 1; }
          ucl_free(out);
          ucl_free(in);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
