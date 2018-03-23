class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "http://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v1.0.0.tar.gz"
  sha256 "0cf3b349e99b48882e11ae0cc2985a7ea159dd24b82e7fd03b7d6072ce38b5e4"
  head "https://github.com/Kronuz/Xapiand.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xapian"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xapiand", "--version"
  end
end
