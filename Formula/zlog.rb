class Zlog < Formula
  desc "A reliable, high-performance, thread safe, flexsible, clear-model, pure C logging library."
  homepage "https://hardysimpson.github.io/zlog/"
  url "https://github.com/lisongmin/zlog/archive/v1.2.12.1.tar.gz"
  sha256 "7127b4210728069667db39c6a163ae3fc070fe84a73bad642d5e707642b3b6d2"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zlog-chk-conf", "-h"
  end
end
