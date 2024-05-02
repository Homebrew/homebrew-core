class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.9.0.tar.gz"
  sha256 "59902bea55585d870fd7681eabe6091fbfd1a8776d1950f859d2dbbd510c74bd"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a9f0ed152dc939cfef2fca0f5b909becbac3d518384d7f5477f8dc24fba563b"
    sha256 cellar: :any,                 arm64_ventura:  "9d7f2f6e4e8b3e32d687f051d46e6638becc6a3e161a984640af6c4f058245aa"
    sha256 cellar: :any,                 arm64_monterey: "f001c295b9144280a7172abd89f3dac8cc5935d596fff4e346b1be635952cd56"
    sha256 cellar: :any,                 sonoma:         "bbe09ff4626fdea8b6f01618312dcf4cef31b9c7ddd8d57f036148fbc2e6f085"
    sha256 cellar: :any,                 ventura:        "9eed441407a199bd57a1ab64674ee874bf7d247675c939c858098e4cfaeef6e2"
    sha256 cellar: :any,                 monterey:       "f4b178ad08b086b22a9a1b501858d4b2a224a710fa40384bd9d071d29d6895f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b0d97a657496f8d633a3ffb896264ba5360bf921b71ba0b39ef92b6bf4fc096"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <yyjson.h>

      int main() {
        const char *json = "{\\"name\\":\\"John\\",\\"star\\":4,\\"hits\\":[2,2,1,3]}";
        yyjson_doc *doc = yyjson_read(json, strlen(json), 0);
        yyjson_val *root = yyjson_doc_get_root(doc);

        yyjson_val *name = yyjson_obj_get(root, "name");
        printf("name: %s\\n", yyjson_get_str(name));
        printf("name length: %d\\n", (int)yyjson_get_len(name));

        yyjson_val *star = yyjson_obj_get(root, "star");
        printf("star: %d\\n", (int)yyjson_get_int(star));

        yyjson_val *hits = yyjson_obj_get(root, "hits");
        size_t idx, max;
        yyjson_val *hit;
        yyjson_arr_foreach(hits, idx, max, hit) {
            printf("hit[%d]: %d\\n", (int)idx, (int)yyjson_get_int(hit));
        }

        yyjson_doc_free(doc);
      }
    EOS

    expected_output = <<~EOS
      name: John
      name length: 4
      star: 4
      hit[0]: 2
      hit[1]: 2
      hit[2]: 1
      hit[3]: 3
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lyyjson", "-o", "test"
    assert_equal expected_output, shell_output(testpath/"test")
  end
end
