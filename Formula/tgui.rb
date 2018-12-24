class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.2.tar.gz"
  sha256 "084af94a20b3db1c44bcaa0a8c49628dfb90c1e83ff16471428ed4649be6d6a9"

  bottle do
    cellar :any
    sha256 "dc2e7583c8294d0ad1f314e35db130b3eea4ed329e81003ad4df808b90fa7f45" => :mojave
    sha256 "728d86aad229f2c200736753792c2e508b00072a499b5c82107eb65351268d61" => :high_sierra
    sha256 "3f5ff4192768e03be629c5c60e34f6fca0e15e642dbf6e81c23784d9ba4dc910" => :sierra
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
