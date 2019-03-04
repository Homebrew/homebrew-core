class Sjasmplus < Formula
  desc "SJAsmPlus: Z80 cross-assembler"
  homepage "https://github.com/sjasmplus/sjasmplus/wiki"
  url "https://github.com/sjasmplus/sjasmplus/archive/20190304.tar.gz"
  sha256 "cea408eb3019d9f09af1996654e959ae97d7d1b4d7561655f3305f701d0f2286"
  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "sjasmplus"
  end

  test do
    system "true"
  end
end
