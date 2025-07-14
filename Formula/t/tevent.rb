class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.17.0.tar.gz"
  sha256 "7702fb373b69da2960b86134b6a9ec6fa0b949a01756fec00a4a6a43575c8361"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28e48cf517dc531e4538ad6d49749c6a06b63fda86bfaf5541ed3198abf1ffbe"
    sha256 cellar: :any,                 arm64_sonoma:  "173ee038f789804174388a00094d632599a4d4c70393245359a13030c98f0433"
    sha256 cellar: :any,                 arm64_ventura: "b7acddbdfcda8ac6b461bcd343053c0b1be49861851de0c2836a4905019b81c8"
    sha256 cellar: :any,                 sonoma:        "7c1a7d19ab1039b131f4de509fb70234e531511dfbf48f5a2b1d88d3f920edd8"
    sha256 cellar: :any,                 ventura:       "548e66b6f5c53d94fd7faa0ca9baae2636ee7ce4b1a488ad9295a8be2deadae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72a6634dde042c3f388bc9d545a2154013608b165098f2628cd1a9563555bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4fd7bb86299828dc6d21b17c915e2e94e3b27c8b49e8ed213f0e6c7d7f429f6"
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
