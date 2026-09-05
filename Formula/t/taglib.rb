class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.org/releases/taglib-2.3.2.tar.gz"
  sha256 "3ca2d8afaa7f1cf7f6ed10e511ebc368bfacd6dcaa3dbfa690b89e502e8963dc"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  compatibility_version 1
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d8c52b4c84c767b812813e014c4a4bf07d5906e281cc9d12c3e2a41d6de5b4a5"
    sha256 cellar: :any, arm64_sequoia: "d0c4b888ad066f830a5725ae3cee6c96b871193214303629fb9f484e15e519f0"
    sha256 cellar: :any, arm64_sonoma:  "ce74ab9da6700f72cd203c363e942697dfe90b53973d9b0e83b9b908108c0102"
    sha256 cellar: :any, arm64_linux:   "63a94c6608f23e771db76356722dd56e6af83504ebc6b39542577520b39c9a63"
    sha256 cellar: :any, x86_64_linux:  "a7d97e83d422731fb5754c56db9cc0e861df08e319c92d51f6b4875a04322062"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[-DWITH_MP4=ON -DWITH_ASF=ON -DBUILD_SHARED_LIBS=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <taglib/id3v2tag.h>
      #include <taglib/textidentificationframe.h>
      #include <iostream>

      int main() {
        TagLib::ID3v2::Tag tag;

        auto* artistFrame = new TagLib::ID3v2::TextIdentificationFrame("TPE1", TagLib::String::UTF8);
        artistFrame->setText("Test Artist");
        tag.addFrame(artistFrame);

        auto* titleFrame = new TagLib::ID3v2::TextIdentificationFrame("TIT2", TagLib::String::UTF8);
        titleFrame->setText("Test Title");
        tag.addFrame(titleFrame);

        std::cout << "Artist: " << tag.artist() << std::endl;
        std::cout << "Title: " << tag.title() << std::endl;

        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltag"
    assert_match "Artist: Test Artist", shell_output("./test")

    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
