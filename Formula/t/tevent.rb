class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.17.2.tar.gz"
  sha256 "e53b1ac288d017d66dde0471cd429a806168ecf07179d7f019572d7a7e05f0d6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61d735b0f3f2b5b6d4fdda58810b10dd286bd3a584f1fb3abde8285aed6b7a40"
    sha256 cellar: :any, arm64_sequoia: "cc86cdef215a345a3d4700060d47f3568f05794797fa20829cd94fc86098d9f2"
    sha256 cellar: :any, arm64_sonoma:  "4a345f1514eec67d12eba97e6218ff0145dc2807212ea981e9fb955f6e84ea9d"
    sha256 cellar: :any, sonoma:        "5e165686744d782c04bd3dc6737c02da676bdf70de10b3b6456bf74fcdd0459a"
    sha256 cellar: :any, arm64_linux:   "487933783e91c33a535b8a46f0b6c0612068a062ccd62f1c103150d23f2356f5"
    sha256 cellar: :any, x86_64_linux:  "7d46173c3b86ada8d64d36e36616de9e246204978cd726e93515db10b22ac2be"
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

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltevent", "-L#{formula_opt_lib("talloc")}", "-ltalloc"
    system "./test"
  end
end
