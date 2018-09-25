class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.0.tar.gz"
  sha256 "ba35b98ff53d7041842d6e770a51d698407e6cb1038cd95872c33036032c167c"

  bottle do
    cellar :any
    sha256 "88096b417c5a8b9282cc05a11e2477adf38befa8401869ac84a74cc00f2c7877" => :high_sierra
    sha256 "07c1e772bd19375796830af0fe28e567b1d05516507ca0a871586afed4eb0b35" => :sierra
    sha256 "6421f8a014f5246fd3261eef0c3d9b1030139081d02c24dad865ba635e601f25" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <TGUI/TGUI.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
