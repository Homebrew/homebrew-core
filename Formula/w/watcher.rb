class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.14.4.tar.gz"
  sha256 "6e8631d62c360345f26b1b8a664a57551fc2c47058c48bf6094aec2b459b44dd"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdfb49605c5b99ae652b3cf682cffab00517e73c6a953e813490a9c28fdf950c"
    sha256 cellar: :any,                 arm64_sequoia: "54381de2acc82f77ea0aeb3f8eaeba8ab4c935b471f6a5e46611e95b1a56a382"
    sha256 cellar: :any,                 arm64_sonoma:  "be51e25efbc1b908bacf4a62358f05dedf03fcb8d0f4fa99f4917d7cceb35d80"
    sha256 cellar: :any,                 sonoma:        "bd21211463d69c79a7f00fad9a9e3f7d47844af62d703ee047efe12916defc4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81bb6064ab2d87be9766ad05ec57aac1d511a91dbbca491b686ac34ee3ee9b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433df53c5dfd5dbc2584846406e6659b444de5a992213bacbae26afbbecc6165"
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
