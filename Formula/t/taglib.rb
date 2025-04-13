class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-2.0.2.tar.gz"
  sha256 "0de288d7fe34ba133199fd8512f19cc1100196826eafcb67a33b224ec3a59737"
  license all_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bcee4f3d052cbe5989067daf7a174503c25b7192cf061776cdd907b466ff3058"
    sha256 cellar: :any,                 arm64_sonoma:  "4294daac491a5377c5600ffc009127c145ee9b57b326a2e0ddb36fbfa392a1cc"
    sha256 cellar: :any,                 arm64_ventura: "74dbb8c6094f04e047bfd5fa118a979f477d071b9cf836418e3b0f937903e121"
    sha256 cellar: :any,                 sonoma:        "98bc5de27c719c40923a8a9b949cede60d16e5fe6fced83e77feed4add720251"
    sha256 cellar: :any,                 ventura:       "8841e4c1db0f37278adc2f3c62b0b115c55293bc277e1e2f99b8c545b8ba73e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc4caad6f5f00412d88bd96a6e1f2e3a58cda1d7760af66439e3d1b46d195cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43bb70deddf02f695e91b7f4c4153b4f690133e5e03a711a27790a0a4172c28"
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
