class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/5.0.0.tar.gz"
  sha256 "d88cd8cece80162a2d7a1a0801aa4fc771d4ed6b094b475d00f303eda30bc87d"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "f803ecfe6908f5cd9e6730b44461296a66635731e05bcf0bc722fca5285a3ab5" => :sierra
    sha256 "edbb531f5133cb24b93b9c85da5be30092c7eb0c025bb4d7567a6547c43fb5fe" => :el_capitan
    sha256 "72743aa820db3795ce1be45d532cf0a05f46ced039afa39eeb6047d7f0f39888" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
