class Ulfius < Formula
  desc "HTTP Framework for REST Applications in C"
  homepage "https://babelouest.github.io/ulfius/"
  url "https://github.com/babelouest/ulfius/archive/refs/tags/v2.7.15.tar.gz"
  sha256 "19cf789b2af1919b69f77c7701237bfc318a9781ec657b68fd4b6ffa9d53f111"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bb83f403a0e3afaaa29a55a287d41397502b098108788889be264e68fa406f93"
    sha256 cellar: :any,                 arm64_sequoia: "caf3377e92811c768853a8751e55284e0f5ff6e490cfc43a1943255d41018e57"
    sha256 cellar: :any,                 arm64_sonoma:  "98e664b0cee9d34cdfd0830c01a3694fb59a0156d5e98ac280c54f29a4cd86e6"
    sha256 cellar: :any,                 sonoma:        "4707acefa7e44fd8b0be6be3640a4a04653f408b47012eb1876d8406dac60a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa30b970d73f41cc23d168a1da27b10d119051f4c20723a14729f6abfb59c8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa9e86ea46c664fe30c62b97cab094df477efab25d300e1c5e6cf9bfecc1afad"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libmicrohttpd"
  depends_on "orcania"
  depends_on "yder"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DWITH_JOURNALD=OFF
      -DWITH_WEBSOCKET=on
      -DWITH_GNUTLS=on
      -DWITH_CURL=on
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "ulfius-build", *args, *std_cmake_args
    system "cmake", "--build", "ulfius-build"
    system "cmake", "--install", "ulfius-build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <ulfius.h>
      int main() {
        struct _u_instance instance;
        ulfius_init_instance(&instance, 8081, NULL, NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lulfius", "-o", "test"
    system "./test"
  end
end
