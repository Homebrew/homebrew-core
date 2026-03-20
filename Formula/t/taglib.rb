class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.2.1.tar.gz"
  sha256 "7e76b5299dcef427c486bffe455098470c8da91cf3ccb9ea804893df57389b5e"
  license all_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9315a7d9f236c78d35ac88daee8705298e425718f97ce3494bde03bdb8506426"
    sha256 cellar: :any,                 arm64_sequoia: "6d1d590a442ccc669c24fa9b8727962bab762682044cc321cca18fd5a739b005"
    sha256 cellar: :any,                 arm64_sonoma:  "a0773f69906e88dc041d145156d5686e7737932081ddd98a2593ec3ef423d130"
    sha256 cellar: :any,                 sonoma:        "24e7ccdd3c1259ccb23f4e2095171d26867721811bb140a5c9f863377e09debb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6178db89831024c5de4baef2d8a1164a4959b744596bf1540b670d6da623ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4daf489c39964118ce9ce2d818ce33b672c31c56f656a8210865ce315bfb835c"
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
