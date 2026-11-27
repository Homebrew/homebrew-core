class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.17.4.tar.gz"
  sha256 "ffe5eff04c26fba4f710942635a4e520f9000c96cf1ad0c7cab16a516d93c852"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "5e1ea5d63aba7eee06e21c6205f03630328708ef495034742d91925aef9f3b24"
    sha256 cellar: :any, arm64_golden_gate: "539b9e5c2b7dce61575153fb563b436f23e8972d73225c61bd3ef450685488f2"
    sha256 cellar: :any, arm64_tahoe:       "8d4391131337d1f4f35f27d45a34c5bca34f671898f8334a5708740ae84d274b"
    sha256 cellar: :any, arm64_sequoia:     "90d30b87939a52d65bf537ca2bc21b93f3078b9afdab9eb0c8fc2ecff7b28b5a"
    sha256 cellar: :any, arm64_linux:       "df7514f8a9e49222e043c149b4396a698cc3b4eb9e49f3dbe9c39be5268a4970"
    sha256 cellar: :any, x86_64_linux:      "b089f6ce88081c17127ab173e02f42eb20ec7991139b54974c313918ea26d68d"
  end

  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "talloc"

  uses_from_macos "python" => :build

  deny_network_access!

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
