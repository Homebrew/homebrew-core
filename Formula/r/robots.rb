class Robots < Formula
  desc "Google's robots.txt parser and matcher as a C++ library (compliant to C++11)"
  homepage "https://github.com/google/robotstxt"
  url "https://github.com/google/robotstxt/archive/455b1583103d13ad88fe526bc058d6b9f3309215.tar.gz"
  version "0.1.0"
  sha256 "618cdd42d4662dcfc6ff2da25854cc0039e664df1a5caff7026acb4074c8e269"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "c-build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "c-build"
    system "cmake", "--install", "c-build"
  end

  test do
    (testpath/"robots.txt").write <<~EOF
      User-agent: *
      Allow: /

      Sitemap: https://example.com/sitemap.xml
    EOF

    assert_match "user-agent 'Googlebot' with URI 'https://example.com/example': ALLOWED",
      shell_output(bin/"robots #{testpath}/robots.txt Googlebot \"https://example.com/example\"")
  end
end
