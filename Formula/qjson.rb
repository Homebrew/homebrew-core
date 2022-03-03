class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage "https://qjson.sourceforge.io"
  url "https://github.com/flavio/qjson/archive/0.9.0.tar.gz"
  sha256 "e812617477f3c2bb990561767a4cd8b1d3803a52018d4878da302529552610d4"
  license "LGPL-2.1"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_monterey: "50e66e18c82d7808bc50db9a48d9c45bf1fe44cc1089c518d72ac07f41c1e37d"
    sha256 cellar: :any, arm64_big_sur:  "4f0e62ecfb61f24dcc04fac054e6c1c2caf56fe674f4f548bcaa16d5dd1c3d3f"
    sha256 cellar: :any, monterey:       "8117225aa84d5a3cb87d50728bec05abc0585efdf88de5c04012263fe2b91ebf"
    sha256 cellar: :any, big_sur:        "37704aff31b79e0ebe73592149836706f579a2a3dd5231aa4e992647eff07ad5"
    sha256 cellar: :any, catalina:       "b262d77517e48cdd798e237e787c2058d4fad0acf71457c82c17113635898fed"
    sha256 cellar: :any, mojave:         "c7b92230e40e860996163997a092575b6317c631221db79cd1031aec61c13b2c"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qjson-qt5/parser.h>
      int main() {
        QJson::Parser parser;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqjson-qt5",
                    "-I#{Formula["qt@5"].opt_include}",
                    "-F#{Formula["qt@5"].opt_lib}", "-framework", "QtCore"
    system "./test"
  end
end
