class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.2.tar.gz"
  sha256 "c89e7ebd450535e77c9230fac3985fcdce7bee05e06c9cd0bc36d50184e9c9dd"
  license all_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0044355186d153ad651115e26d09394ddc11239309fa0fb0c7c95aeb8e4240a"
    sha256 cellar: :any,                 arm64_sequoia: "aba6369a993f148591a3e714bc470f4ada52e63837fc188a383ba1f7d113e8de"
    sha256 cellar: :any,                 arm64_sonoma:  "e84e807e6890ba7bb3ad27334c6973ff82733a29b380031dd30c03105c878ec8"
    sha256 cellar: :any,                 sonoma:        "e76523d01007ea5b5009701443c70f718c74a7e35c564ece10dc691b9ec9395e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4018c10b274e6b50c87c2fd733a78394f84e26f5ac76978231124f90c733c1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d173f67508c1856472128df632dbae773ad1035da34c728d9166b6f6753c46e"
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
