class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.6.tar.gz"
  sha256 "d2a9890b5d394311ca08cea53f6ecc1e9e2566a5adfe4e829a26ac1d7d974dfa"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f71809a7937ee6d36f429d5edabb3455ee90c7a2c0ffd1e263ca5b87f2623978"
    sha256 cellar: :any,                 arm64_sonoma:  "e1f6cc5b98e72cb77b1dd02707dc2c13f32aa644253eb24e7db4dce37960c299"
    sha256 cellar: :any,                 arm64_ventura: "703b5264a40f62cf192dd70c97a84776fb9c29816c9149f56d27407b16b89bdf"
    sha256 cellar: :any,                 sonoma:        "33bbd0c78a1faadc10b4473c422c958281cf368c424c3c52cc2df7bb4a195bec"
    sha256 cellar: :any,                 ventura:       "9137c812d670de80acd11b43a544c53f86ca45502c3c5b74ca761f3838053033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e5ef87b148b16035b38adaa38466f232bf0c9f2f00074418d08fcb15db5c60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df14bd94e63e3dae0bb6f658307897275e50c87c11470a6b0e98ec31fb242c83"
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
