class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org"
  url "https://www.samba.org/ftp/tevent/tevent-0.17.1.tar.gz"
  sha256 "1be2dea737cde25fe06621f84945e63eb71259e0c43e9f8f5da482dab1a7be92"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.samba.org/ftp/tevent/"
    regex(/href=.*?tevent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7447eb820e3be9a34b7dece613895a67f10de300bb30d0e59322467591f3edf"
    sha256 cellar: :any,                 arm64_sequoia: "cf0a28518720b3c7c49c61ab6c9022cae01592fd4080679182cb7b8540f85155"
    sha256 cellar: :any,                 arm64_sonoma:  "d6842bb23c4ce73840132be51a67414f3351c6a6f1aeb8a4f0c4a2c39b2a4853"
    sha256 cellar: :any,                 arm64_ventura: "35724246e278253aa0f95ca74069a1349748379fc0559d00a1ffba72a5178399"
    sha256 cellar: :any,                 sonoma:        "e6a681b4cf04d84f7b6a8ef3f446f9d798238fa38034594194cd777e5f4ff623"
    sha256 cellar: :any,                 ventura:       "a33ba3c6e7c392e14b4f3793449a38b74294b1556b74564eaba98fbcbde7a931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff33cd50247ce9a038e70ad4b99e91e4fe5b71d2127297f0f313188b51733ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2030d92ac3d56d9387cbf24abb485f6699c557f39fce15d6f46b1ea7e03ad6c2"
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
