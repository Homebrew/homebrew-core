class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.2.tar.gz"
  sha256 "d7c788fd55673aef59567f75f061255c6243db583d3bfd5944768b3ee6510cee"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bbe48a136bb675df5f2eedf9037f5679630388ac138432fd8b44532ea557fa97"
    sha256 cellar: :any,                 arm64_sonoma:  "f90c5ffa0af1fc17bb7b7bcec9951bbaf9c55afb5e96820e166685e9ce6a494f"
    sha256 cellar: :any,                 arm64_ventura: "a299d21354784d25dbaaef3945eb5d3bad5c73326aebe22ba7cc0a4ff40933c2"
    sha256 cellar: :any,                 sonoma:        "573bd31fa9cdc5009592c1eee404114b9a685b6be22a3b10fab95a537082acb6"
    sha256 cellar: :any,                 ventura:       "1e842312456ccff1da97df5df435ef1a58e505c46e0f1a29fa6f176d7e27316a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b91612886fb06d34ef734209f2f8280d8ce654df3b973e83c690f9a2b1711d"
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
