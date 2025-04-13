class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.16.2.tar.gz"
  sha256 "f0bbd29dfabbcbbce9f4718fc165410cdd4f7d8ee1f3dfc54618d4c03199cea3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b1299df6043fe06db809e5a5a15d531eafa1e5cf342f49fee336a016522d6c0"
    sha256 cellar: :any,                 arm64_sonoma:  "669b3b3ce670629fca6c41ccd5f47b8dbde8f8dd4d4c7ebff9bf4e79bb3edcd9"
    sha256 cellar: :any,                 arm64_ventura: "f31c16f2155d9ab99761f758df8c64464ade64525b3e0603261c6b2c68fdb58b"
    sha256 cellar: :any,                 sonoma:        "685425f7ed027ead68df7354672600841413b18f702484094ec2d3bf40bfdc35"
    sha256 cellar: :any,                 ventura:       "15bab6c124d0f8afc3d83ca9f8f20b79211fe1ce33ab06e60ce2552ad78c78e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91b7e00fe6fab5edf5cd35f2abffd2f842c456d9c3f098edf007d79eabc397be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36aa2419325a2300e1afcefaa32ef7982bbb44855a9ea104322c1c6e43f49a3c"
  end

  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "talloc"

  uses_from_macos "python" => :build

  def install
    system "./configure", "--bundled-libraries=NONE",
                          "--disable-python",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # https://tevent.samba.org/tevent_events.html#Immediate
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <unistd.h>
      #include <tevent.h>
      struct info_struct {
        int counter;
      };
      static void foo(struct tevent_context *ev, struct tevent_immediate *im, void *private_data) {
        struct info_struct *data = talloc_get_type_abort(private_data, struct info_struct);
        printf("Data value: %d\\n", data->counter);
      }
      int main (void) {
        struct tevent_context *event_ctx;
        TALLOC_CTX *mem_ctx;
        struct tevent_immediate *im;
        printf("INIT\\n");
        mem_ctx = talloc_new(NULL);
        event_ctx = tevent_context_init(mem_ctx);
        struct info_struct *data = talloc(mem_ctx, struct info_struct);
        // setting up private data
        data->counter = 1;
        // first immediate event
        im = tevent_create_immediate(mem_ctx);
        if (im == NULL) {
          fprintf(stderr, "FAILED\\n");
          return EXIT_FAILURE;
        }
        tevent_schedule_immediate(im, event_ctx, foo, data);
        tevent_loop_wait(event_ctx);
        talloc_free(mem_ctx);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltevent", "-L#{Formula["talloc"].opt_lib}", "-ltalloc"
    system "./test"
  end
end
