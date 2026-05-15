class Watcher < Formula
  desc "Filesystem watcher, works anywhere, simple, efficient and friendly"
  homepage "https://github.com/e-dant/watcher"
  url "https://github.com/e-dant/watcher/archive/refs/tags/0.14.5.tar.gz"
  sha256 "190bbe5e19923083db2beb3aa68f4e99a563c8f685d8037b0536780b0116c4d3"
  license "MIT"
  head "https://github.com/e-dant/watcher.git", branch: "release"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "739685078edc48db766556d91a9fcd4f17da74c1c67da8228db762c64e8366c1"
    sha256 cellar: :any,                 arm64_sequoia: "04676a32fcee2729a167300abf014303af7a943b9f34bdb9e16a0bf4a0c0ca9e"
    sha256 cellar: :any,                 arm64_sonoma:  "b630b14e20d03790102b9d9d86b93c99757eb14be313ab1b7acc9cc93ca4bf9e"
    sha256 cellar: :any,                 sonoma:        "db6db083bb5006cdcfd9260e7e6e08c10d0bb1df8648431e975d54c09d7d9e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1036a5c22d84a193a05a44cd44486a76f94d13d45bac789ed35236a462db81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55db0f93a4bde710d9f45754dac33a8ba8b1532750c909169eafafcb115bf863"
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
