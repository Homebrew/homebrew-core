class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.8.tar.gz"
  sha256 "8e1ac50617bed910be829da3701f42d8419038703db934a09e5ec896e6ef679c"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "933c075dff274fe0d3a21c14476a89a90ee5c02d62ba8cf8fafefa4378f693a6"
    sha256 cellar: :any,                 arm64_sequoia: "20b33693f334149c635b8f5728e5fbf0b446056ed3db39b881468eeb09f5eef6"
    sha256 cellar: :any,                 arm64_sonoma:  "40b85eb988949b29d9221599d31b1d75b84123fc7c3c4fd1c855e5816cc07732"
    sha256 cellar: :any,                 arm64_ventura: "b81047fe12b12668f4995b5ce66edbe9034e9520f8e3ca2ffc5a97ebaf769c58"
    sha256 cellar: :any,                 sonoma:        "04b6b6b787f2fe84d3d6e48fc608fd953873e35379f5cf9f44160611d3efb8d5"
    sha256 cellar: :any,                 ventura:       "fb2bf1f28202895c0905046f2aaa825eb1fd207b323f9914d67b34f72cb03b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad964ec883244cafea19d922bef735b6cb4c11c96ed9b534858a4392978cb422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eada47cfd7b6ce4eb100cc7f0efc37cc159bf3cd8db66d1960b9b75f3843613b"
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
