class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.org/releases/taglib-2.3.1.tar.gz"
  sha256 "a19d90e6fd41d09a0281ec0fe762d51491d7a6ccffc923c4f7868c5e647ca230"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  compatibility_version 1
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c2cf7d5ecc8b6f8c2889ec1618b8ec2f3ff697dd9dd0d8ed832499d51dc7a57"
    sha256 cellar: :any, arm64_sequoia: "d9d83ee01ebc5adc20aea5c61ac7b9d3586887321796c5943d05b04c3fd9690d"
    sha256 cellar: :any, arm64_sonoma:  "31a8ead75925ad72b27f24df59be8d3f5a4de0bc438256c3a281c43bcd2732c8"
    sha256 cellar: :any, sonoma:        "83626f71dd49f422010119a1f7c981d0830cad916a6dbe560001fe3e1f583a80"
    sha256 cellar: :any, arm64_linux:   "fc49462273488bc9c4b3f2215c18f8ee1f309104645ce644fb09a44c055d7fa2"
    sha256 cellar: :any, x86_64_linux:  "a4388c6beafdee32ca93b78387173c58c0d78025ce0bd8a5bab510f5021b0634"
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
