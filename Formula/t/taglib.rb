class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.1.tar.gz"
  sha256 "95b788b39eaebab41f7e6d1c1d05ceee01a5d1225e4b6d11ed8976e96ba90b0c"
  license all_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33bae1ce3df75ae42afe0a00e5ff89c13fe89c55a90492f83936871400bead26"
    sha256 cellar: :any,                 arm64_sonoma:  "a8407786ef99bff2dacc49c41ee8597bf0e1b320770cf7e375cbcf3dd01edfa2"
    sha256 cellar: :any,                 arm64_ventura: "5fa5bc0e5f1f0420951a109822212307d4c47eca65e13c80cd12130ef3db7582"
    sha256 cellar: :any,                 sonoma:        "0bcb92f06b8a816e61db238c4866038e32d939d137ae5a9b2b6a89f6354dc060"
    sha256 cellar: :any,                 ventura:       "dc45e7bdf7b98bbc8c82fc504d9f9fc439c0ee404c081f3a9d47db3a43440d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578bbf176f2ab333475f9bf2f1aba06cdc376416eab72610354959efe1255441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90098d41daac6072c0daf0dc6a9a179811a0a7067809018845ef727a6611ca8f"
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
