class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "29a0bdea2c07ae7e7af9f313de5deaa3ab0557e0251eac9b1e418cc18ebc0ba4"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00ad83d05c65d2bdda30f0060cc7272c7bf4d5ad9d12b21d49fff40239fbaf0e"
    sha256 cellar: :any,                 arm64_sequoia: "7279f279832eba4ddf771647a48a313ce98c955c71e494fd6f56a01bc13111a6"
    sha256 cellar: :any,                 arm64_sonoma:  "ce76f3c446370dac0f1a55a34fce6ba853a8d6507de37a2cc4c01d738a825799"
    sha256 cellar: :any,                 arm64_ventura: "485c8c604da333d41415b82c37f00c8bc855b835c939ab3608d02e7a1fdf4ea4"
    sha256 cellar: :any,                 sonoma:        "7815e13075439baadc479570e7dad4cd98b7560abdc3f180280f21aadbf40655"
    sha256 cellar: :any,                 ventura:       "89d9e954d51597342735a7b80ef62ae84ceee980d0d5d06e07bdf85d3839a0e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa81c03e17194b564a81c87c32d4c6f031f00e24e4d85bfff7c7eeaca2e94ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca890469dc821ab187fa7c65eb1835716f238c8a02f9e380798e6eb324f498a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.5.0.tar.gz"
    sha256 "c05cf86445a4bcf8718389fbe6feeaa6091b9f500ddc746a589cdeb60c7c5519"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    resource("rgbobj").stage do
      system "cargo", "install", *std_cargo_args
      man1.install "rgbobj.1"
    end
    zsh_completion.install Dir["contrib/zsh_compl/_*"]
    bash_completion.install Dir["contrib/bash_compl/_*"]
  end

  test do
    # Based on https://github.com/gbdev/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~ASM
      SECTION "rgbasm passing asserts", ROM0[0]
      Label:
        db 0
        assert @
    ASM
    system bin/"rgbasm", "-o", "output.o", "source.asm"
    system bin/"rgbobj", "-A", "-s", "data", "-p", "data", "output.o"
    system bin/"rgbgfx", test_fixtures("test.png"), "-o", testpath/"test.2bpp"
    assert_path_exists testpath/"test.2bpp"
  end
end
