class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.17.3.tar.gz"
  sha256 "8eaa1b1b8d3c36ce8ddeae6d79c9a05360dcba5930115112c078415bcbe0d16d"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "a06e8cee8b5b7978cb2cf64e27db11144e83220273e3119606592166f4dbe2a7"
    sha256 cellar: :any, arm64_golden_gate: "fd8576e5ac11e4095f56f30cd2be5635870928b1d1cb9824a1e0d40601872a4a"
    sha256 cellar: :any, arm64_tahoe:       "36c7a491b5c0826b72f46814774aa36907e987ef8737c1bc9ad2778343baa056"
    sha256 cellar: :any, arm64_sequoia:     "ff82d430f85c5a09fbec0a832ffaa935592c42d37acfdcb036803a34dccc40d4"
    sha256 cellar: :any, arm64_linux:       "da062d551e7781f7af9a07770902906876b4a13ddd9c164082af83905d36c60d"
    sha256 cellar: :any, x86_64_linux:      "ea82673c4926807e4543bc039f56e15f85044d78efb84be224f9e528c0e4d235"
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
