class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.3.tar.gz"
  sha256 "7349f6fd942418bc7009ebe743eb7c9d055f02921ec56fa436ec25007c47fd38"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  compatibility_version 1
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a928c47709f2870b87d973f74358edf18816d8263304f5e4e9911898162107a3"
    sha256 cellar: :any,                 arm64_sequoia: "65e5ecc716029c9d1eae11fb643a18df772980a01a09cad434af97bcba955bdb"
    sha256 cellar: :any,                 arm64_sonoma:  "6b2e26e84d1f58b7a04b40e33bbcdab30f3459779f9229c248f196ca8e94f3d7"
    sha256 cellar: :any,                 sonoma:        "eb9aefea72d75bee73fc35661433d9f2ebd20f408f70c91011b81c3ccb140f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6c5c4793004c5c00d0e1267fd3ac8258a9a136cbfe7b471942543733da76d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051fc7c416146bc92af62e067e517c3ee37b8834f7a7a8ebb66d1f6dd98f11fd"
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
