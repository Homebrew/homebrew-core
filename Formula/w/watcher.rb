class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.4.tar.gz"
  sha256 "fe67b866a9fd4f460126411d30e25c9d3a8d7baf7f41ec6119d3086858412a07"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8955fe0084d72554ab241d30960740d796d331f6a989dbb0f03ac293b27ddee"
    sha256 cellar: :any,                 arm64_sonoma:  "3a6f35e9d7f7cf7bb004ca3824bc671ed43ee83d39d327e66dde0e5770b91405"
    sha256 cellar: :any,                 arm64_ventura: "63d6baae4dab2518d96ba28a201cd25eb6f7bbb582e7bf4824cb174cf42c2c25"
    sha256 cellar: :any,                 sonoma:        "b4b61cf95949d1646d377a9ee4b1b22270dbf86e5049d981058682d35d27c4c0"
    sha256 cellar: :any,                 ventura:       "867e554001654e54d763c2c8b750d0e572fdddeaa4fdb3c7e92abe515a337fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8fd5559c9f70958c783c71c9a8df7829b4b5a35f8d04cf35855617bd2669dae"
  end

  depends_on "cmake" => :build

  conflicts_with "tabiew", because: "both install `tw` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/wtr.watcher . -ms 1")
    assert_match "create", output
    assert_match "destroy", output

    (testpath/"test.c").write <<~C
      #include <wtr/watcher-c.h>
      #include <stdio.h>

      void callback(struct wtr_watcher_event event, void* _ctx) {
          printf(
              "path name: %s, effect type: %d path type: %d, effect time: %lld, associated path name: %s\\n",
              event.path_name,
              event.effect_type,
              event.path_type,
              event.effect_time,
              event.associated_path_name ? event.associated_path_name : ""
          );
      }

      int main() {
          void* watcher = wtr_watcher_open(".", callback, NULL);
          wtr_watcher_close(watcher);

          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwatcher-c", "-o", "test"
    system "./test"
  end
end
