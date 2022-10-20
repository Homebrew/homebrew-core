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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7f82e2d2c969d71a2dbaca2cc6c0f2577c422a16281a981e3193535263803c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef63a86669c63e486c3682494a93c9db453a33089a2a71398efb8e5e26cf5e44"
    sha256 cellar: :any_skip_relocation, monterey:       "4317885999b8297a1919d5d65a9246efdd7bc1807fd2df4a9268a202fbf3a97c"
    sha256 cellar: :any_skip_relocation, big_sur:        "91ce0597dc8e648e4ee0d0caaa30bceb5f569acc90634d88fa5e7859f2ae682a"
    sha256 cellar: :any_skip_relocation, catalina:       "116db1f8157bf88831fece730fb3e6fa82420d53c29b032afd63b979df42b386"
    sha256 cellar: :any_skip_relocation, mojave:         "89c37d38b41d5107f85c0880eb1599c885dafc2a7150a378c645b3fbe1f0e5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1733761c7ce4452219f15055b4d72ca6e287c9c18691d9aa66c4aae0349d28c"
  end

  depends_on "automake" => :build

  def install
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

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
