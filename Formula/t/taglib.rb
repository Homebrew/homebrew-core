class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.1.1.tar.gz"
  sha256 "3716d31f7c83cbf17b67c8cf44dd82b2a2f17e6780472287a16823e70305ddba"
  license all_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f29ef2be3f8ab43a3956a21de1f80d0bb3951df2e16376f592e476a4fe07cf8"
    sha256 cellar: :any,                 arm64_sequoia: "78cd3f2121fab66ac1f4b3f28a54c46d129375e8ece28f7eeb4cb68f2c89722a"
    sha256 cellar: :any,                 arm64_sonoma:  "a8d56fabd553d9d4f5de8a78476f803ea5e6d7d7dc00861f767fbe54b161f50d"
    sha256 cellar: :any,                 arm64_ventura: "3723f18ff63cd33ec1b6da0f7ab43c08be3994c6c70471a9a21025488b5956d1"
    sha256 cellar: :any,                 sonoma:        "4a107bbeb7a9d53f3046d18a19a4161e5e549ab3cf67069d65d506bdc317132f"
    sha256 cellar: :any,                 ventura:       "793d01948030616da5df4d999fba744e7639d5441aff12e83b1fec516042cc87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f60f5717e204f3b8e059ca019f928b8b95a46ad1c40fe96b5903b867874881a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04369b3a1ba6dcdfd99b354eb9c92106f7c507f1819b68b349d1798478c6cab1"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp"

  uses_from_macos "zlib"

  def install
    args = %w[-DWITH_MP4=ON -DWITH_ASF=ON -DBUILD_SHARED_LIBS=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltag", "-I#{include}", "-lz"
    assert_match "Artist: Test Artist", shell_output("./test")

    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
