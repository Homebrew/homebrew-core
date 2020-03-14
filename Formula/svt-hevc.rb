class SvtHevc < Formula
  desc "Scalable Video Technology for HEVC Encoder"
  homepage "https://01.org/svt"
  url "https://github.com/OpenVisualCloud/SVT-HEVC/archive/v1.4.3.tar.gz"
  sha256 "08bf2b1075609788194bf983d693ab38ed30214ec966afa67895209fd0bf2179"
  head "https://github.com/OpenVisualCloud/SVT-HEVC.git"

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/SvtHevcEncApp --version")
  end
end
