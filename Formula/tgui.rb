class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.5.tar.gz"
  sha256 "10d3cc3747acc6c5d7e4fd7de2e56fb63c4af6741f51dae825bf69267a3c8479"

  bottle do
    cellar :any
    sha256 "3671c5afa64e831e87f7590c867ca378a9e5e7a2b1e24718232a7b9c00c4fddf" => :mojave
    sha256 "d60d14ce0bce08e43de253a7b15fdde661b4c7656b4cf83fc19a93ffdde8b30b" => :high_sierra
    sha256 "7c029c36a0cdf8a2b0c66a0f9a7c1b21edb3e518b25a9f44fb4c9c5c70ce4d38" => :sierra
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
