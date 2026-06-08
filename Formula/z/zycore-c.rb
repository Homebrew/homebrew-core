class ZycoreC < Formula
  desc "Zyan Core Library for C"
  homepage "https://github.com/zyantific/zycore-c"
  url "https://github.com/zyantific/zycore-c/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "943f91eb9ab2a8cc01ab9f8b785e769a273502071e0ee8011cdfcaad93947cec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bd66ff88f720bf9c47da552f6072331448fe84df5b7da0279f92c0b40987a97"
    sha256 cellar: :any,                 arm64_sequoia: "80c639348dfe12bbcd9a604189ca4fa8efe291b8a75085a96bc93d6fbba1e74f"
    sha256 cellar: :any,                 arm64_sonoma:  "65c26276d69063393eedac9a756af987a8a8aa7e3bd26fd8a90546382dae9278"
    sha256 cellar: :any,                 sonoma:        "b94facc5565aa5091503172da72a453a990e22b01c096db5c5e475399390eee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3473fe4aa08dfd152aa063dc3e9968c3e1850efe0d9b3218cc82ced2fa90e067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb6c52be79607df63982e518a665f8bcaaf5d601f8d633ffe4646ce505e8787"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZYCORE_BUILD_SHARED_LIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <Zycore/Status.h>
      #include <Zycore/String.h>

      static ZyanStatus TestDynamic(void) {
        ZyanString string;
        ZYAN_CHECK(ZyanStringInit(&string, 10));

        ZyanStringView view1 = ZYAN_DEFINE_STRING_VIEW("Hello World!");
        ZYAN_CHECK(ZyanStringAppend(&string, &view1));

        const char* cstring;
        ZYAN_CHECK(ZyanStringGetData(&string, &cstring));
        printf("%s", cstring);

        return ZyanStringDestroy(&string);
      }

      int main(void) {
        if (!ZYAN_SUCCESS(TestDynamic())) {
          return EXIT_FAILURE;
        }
        return EXIT_SUCCESS;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lZycore"
    assert_equal "Hello World!", shell_output("./test")
  end
end
