class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.13.5.tar.gz"
  sha256 "3d5c3809e7be28f06eb6b8d077cfb3fab4fd05ac653d2540643b05c93273803a"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71d27cb20d333bddbe57770a8b59aefa5646ce23eaa943b4d25ac0ce3fb49102"
    sha256 cellar: :any,                 arm64_sonoma:  "d5ebbf8298ddbdcc5394cc263ba4aadb5580717683c95c30145b159760d4aed4"
    sha256 cellar: :any,                 arm64_ventura: "53157a0f1edf216242266fd6a9f7d0c8932d0ce54effc46f545bf54658c9e792"
    sha256 cellar: :any,                 sonoma:        "c7f39e92be6da2d9f7146e06c379eea38819886c6a39da7df10e4dd766550725"
    sha256 cellar: :any,                 ventura:       "18a9f158c5b2bdb1bdfb8ca6e1222a0990826234590fd4badca6c7a424b02585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f56147c3c007a937ba7b42ad907f7492df64edd3ce054d064bfb96a98afb7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b48edcac1609f95123e313cd24069ffcc0f5de6aa10d594892d4492ffd3e54e"
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
