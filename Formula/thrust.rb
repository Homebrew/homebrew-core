class Thrust < Formula
  desc "Parallel algorithms library which resembles the C++ STL"
  homepage "https://thrust.github.io/"
  url "https://github.com/thrust/thrust/releases/download/1.8.2/thrust-1.8.2.zip"
  sha256 "00925daee4d9505b7f33d0ed42ab0de0f9c68c4ffbe2a41e6d04452cdee77b2d"
  head "https://github.com/thrust/thrust.git"

  def install
    (include/"thrust").install Dir["*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <thrust/host_vector.h>
      #include <thrust/device_vector.h>

      #include <iostream>
      int main()
      {
        thrust::host_vector<int> H(4);

        H[0] = 14;
        H[1] = 20;
        H[2] = 38;
        H[3] = 46;

        H.resize(2);

        thrust::device_vector<int> D = H;

        D[0] = 99;
        D[1] = 88;

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    system "./test"
  end
end
