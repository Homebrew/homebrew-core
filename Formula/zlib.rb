class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.2.12.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.12/zlib-1.2.12.tar.gz"
  sha256 "91844808532e5ce316b3c010929493c0244f3d37593afd6de04f71821d5136d9"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3c956cfb722564f26a8c50a89293971089a7017f363c823d432e1c90c16b87c"
    sha256 cellar: :any,                 arm64_big_sur:  "0cb865dc3adb641c0f4f7301d7ad66ab5b23ac76afe61e21d865c12f0ab5d03a"
    sha256 cellar: :any,                 monterey:       "5072d7b94690a52220f7a9f6cc566f87998a380e3f2fcd8a386caf7dbd5f19c4"
    sha256 cellar: :any,                 big_sur:        "3db997820d0f7cbd3de13fda10f731949f44cb19f3923be18686ae5d65ec2e7f"
    sha256 cellar: :any,                 catalina:       "71657247458cf1aa4f1b548aff059e65b182ef5fdf86740071f7f60c5520b370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b1d8f0500bbccdf5cc466e7acbd7eddc40cd1465687239af423389abe4f46e"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "glibc@2.13" => :build
  end

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  # Patch for configure issue
  # Remove with the next release
  patch do
    url "https://github.com/madler/zlib/commit/05796d3d8d5546cf1b4dfe2cd72ab746afae505d.patch?full_index=1"
    sha256 "68573842f1619bb8de1fa92071e38e6e51b8df71371e139e4e96be19dd7e9694"
  end

  # Patch for CRC compatibility issue
  # Remove with the next release
  patch do
    url "https://github.com/madler/zlib/commit/ec3df00224d4b396e2ac6586ab5d25f673caa4c2.patch?full_index=1"
    sha256 "c7d1cbb58b144c48b7fa8b52c57531e9fd80ab7d87c5d58ba76a9d33c12cb047"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert_predicate testpath/"foo.txt.z", :exist?
  end
end
