class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.1.0.tar.gz"
  sha256 "2a1df8195b06f9a057bd4c7d987697be2fdcc9d169e8d550fcf68e5d7f129d96"

  bottle do
    sha256 "abadd9accf9e08e669aaec62c98c43302056e3ac58a67b8375de03a187fe7d64" => :sierra
    sha256 "12fe570a4ae1cf3ca67b10ec15c7d0e0ca42f042d0c658b97635d9df1e980419" => :el_capitan
    sha256 "6ebde647bc0d32568558c0aa9068f8bcc193e1717db3725f736db066b5fcf8c5" => :yosemite
    sha256 "142073838f66e741178ff7c793791a5cd1118a04d112efae56f7769ac05646fb" => :x86_64_linux
  end

  option :cxx11

  depends_on "cmake"     => :build
  depends_on "gsl"       => :recommended
  depends_on "eigen"     => :recommended
  depends_on "jpeg"      => :recommended
  depends_on "libdc1394" => :recommended
  depends_on "libpng"    => :recommended
  depends_on "libxml2"   => :recommended
  depends_on "opencv"    => :recommended
  depends_on "zbar"      => :recommended
  depends_on :x11        => :recommended

  def arg_switch(opt)
    build.with?(opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_DEMOS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TUTORIALS=OFF
    ]

    args << "-DUSE_CPP11=ON" if build.cxx11?

    args << "-DUSE_DC1394="       + arg_switch("libdc1394")
    args << "-DUSE_GSL="          + arg_switch("gsl")
    args << "-DUSE_EIGEN3="       + arg_switch("eigen")
    args << "-DUSE_JPEG="         + arg_switch("jpeg")
    args << "-DUSE_OPENCV="       + arg_switch("opencv")
    args << "-DUSE_PNG="          + arg_switch("libpng")
    args << "-DUSE_X11="          + arg_switch("x11")
    args << "-DUSE_XML2="         + arg_switch("libxml2")
    args << "-DUSE_ZBAR="         + arg_switch("zbar")

    mkdir "macbuild" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <visp3/core/vpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s
  end
end
