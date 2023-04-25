class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "119970f1e00667045eb12775db10611fc04f9158348144913c9e233f98664714"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ecfe2b5d545259933c801b393c2bd3e7a54414a71a8cdb53a0ba50f47a5b760e"
    sha256 cellar: :any,                 arm64_monterey: "8e6228f077cf83571ad12a696ba30d65178d501b7b62ec773c20472655126b24"
    sha256 cellar: :any,                 arm64_big_sur:  "db2b61f9eb87e5fef99cd20dba0f30a5f2edda2d8e39a208a3bf28f4c8d97d26"
    sha256 cellar: :any,                 ventura:        "eab513161cc50d914f87a9636690638a98602d3e46b06d1a5e13d75fc5d69522"
    sha256 cellar: :any,                 monterey:       "33357da3c451e6adeb7e1a841f3b28f894202e6a9a24eb686656f9aad8160430"
    sha256 cellar: :any,                 big_sur:        "3b37cbb5281175e0f2abdf71548adccb6e1935f789be069f89e165852002ea33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1cbbed66a84f67a944f46dfa1b56d32e6c20b45c4daca6286d1faadea6325b4"
  end

  depends_on "cmake" => :build

  resource("test_video") do
    url "https://archive.org/download/test_bunny_202304/test_bunny.yuv"
    sha256 "6c7e90db57f5097d05d735757d72ef2ef4d5a3c0da562706fd9cfa669535e797"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("test_video").stage testpath
    system bin/"vvencapp",
           "-i", testpath/"test_bunny.yuv",
           "-s", "360x640",
           "--fps", "60/1",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath/"test_bunny.vvc"
    assert_predicate testpath/"test_bunny.vvc", :exist?
  end
end
