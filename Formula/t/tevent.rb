class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.16.1.tar.gz"
  sha256 "362971e0f32dc1905f6fe4736319c4b8348c22dc85aa6c3f690a28efe548029e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e46049d02fd8a4331fca78b2197a3c702455f338f8100f2faf83b1ea21022d35"
    sha256 cellar: :any,                 arm64_sonoma:   "7d039f07bfffebd67e55ac0cb343ddb5947aa24d630b4c4d0ac1731d37d7b503"
    sha256 cellar: :any,                 arm64_ventura:  "4c7c644207c00731d6cd097afa536cd181a4f5f036326ec78c999d8f8c4c71fb"
    sha256 cellar: :any,                 arm64_monterey: "7fd475a600b2e91c816b8f5b79240912efdcffe568f655828cbf470e9b4bb09c"
    sha256 cellar: :any,                 sonoma:         "5f64884156927c8cce98b780410f714d7bbfa1fec900102da97ecd40b9cc5a17"
    sha256 cellar: :any,                 ventura:        "6d528308309d15c55d95de0bd05cf6bb33196c6ad4773de19714154ec7245edf"
    sha256 cellar: :any,                 monterey:       "ebf65db04c8a2d0ecdcd6bd5e391d01d3797932e14bfad4b09ac98faa5a57258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67629f6fedc330607a6af2a35ef61fe462a012425de9bfce501688a2cb02d3a"
  end

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
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
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltevent", "-L#{Formula["talloc"].opt_lib}", "-ltalloc"
    system "./test"
  end
end
