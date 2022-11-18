class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v2.3.3.tar.gz"
  sha256 "2979c96123a1cf1afc14a931aab7a1376986e047b0927f450093f4cbae4eb04c"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37522650dacd64e3169554f8f8d27277ec26e7e109ccdfc015dc4a97ae02638d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894a1587ffd665c57c06486a4bbbacb71212b9ddb1473e6988105f9b099dcd92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e41066f85ac6b8e0d7c48e05d5183b132f2f8a0707bf9d1e12c4fee59fc1ff38"
    sha256 cellar: :any_skip_relocation, monterey:       "c6254c01ea05237c9e4ae20de563d0a884b6b4cb06c0885f5df825f7ea0522e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "41abdbfc866306577d3a0aa6a42f718fdb9fc2a6f0e1e83d8e3d08ffd491d1ec"
    sha256 cellar: :any_skip_relocation, catalina:       "93704a8ae200de568c7092c230f2d4adb5c23a9723353ca923d808aa21f9d0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50eade8bd4105e778ea9282c16a3656278e893f86ea3f4932eade759abea8c4"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    mkdir "quill-build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        quill::Handler* file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", file_handler);
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
