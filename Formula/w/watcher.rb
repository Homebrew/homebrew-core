class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.14.3.tar.gz"
  sha256 "40431a0871b9a17605c954e2a6a6e9295bc014310f7e7c6966a728decd2dedfc"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d862587022a3c0ff12848b4dad929b7efde430930a8fc4d822219caa180ab7a"
    sha256 cellar: :any,                 arm64_sequoia: "9082a298ec2ad958333cadfff67aa40d0a1d0c76a6b61e30af3b0bcb2570a1b1"
    sha256 cellar: :any,                 arm64_sonoma:  "985dead4a8e9f364c488485fc17831cf83ada0a064f1866e5b120594c97a074a"
    sha256 cellar: :any,                 sonoma:        "07b468b1402778e63d3389a7fdde846e60c92396121e6a87d7e75bca7d8cc5b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e100d15ccdbfab597b728fa0e8ff4d226cdaa4b7ea68f90e3d3f7270ffdc451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2486ce0c12479efdcce5d588de0cb0357e8dbaff35c411073a64a4ff98b8887e"
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
