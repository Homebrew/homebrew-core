class Zydis < Formula
  desc "Fast and lightweight x86/x86-64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis/archive/v2.0.2.tar.gz"
  sha256 "bd711102a5a30096562a7cb60bafbc9c4a2441ce5463a59f4d16f2dd73f9fb72"
  head "https://github.com/zyantific/zydis.git"

  depends_on "cmake" => :build

  def install
    mkdir "zydis-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      bin.install "ZydisDisasm"
      bin.install "ZydisInfo"
      bin.install "ZydisFuzzIn"
      bin.install "ZydisPerfTest"
    end
  end

  test do
    system "#{bin}/ZydisInfo"
  end
end
