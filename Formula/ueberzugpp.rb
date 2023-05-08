require 'pty'
require 'tmpdir'

class Ueberzugpp < Formula
  desc "Drop in replacement for ueberzug written in C++"
  homepage "https://github.com/jstkdng/ueberzugpp"
  url "https://github.com/jstkdng/ueberzugpp/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "3f7e21052c3c218c436b1d2d8aedc1f02573ad83046be00b05069bfdc29bf4e2"
  license "GPL-3.0-or-later"

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "cppzmq" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "libsixel"
  depends_on "openssl@3"
  depends_on "spdlog"
  depends_on "tbb"
  depends_on "vips"
  depends_on "zeromq"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_X11=OFF",
                    "-DENABLE_OPENCV=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink "ueberzug" => "ueberzugpp"
  end

  test do
    master, slave = PTY.open
    read, write = IO.pipe
    pid = spawn("#{bin}/ueberzugpp layer -o iterm2", :in=>read, :out=>slave)
    sleep(0.1)
    read.close
    slave.close
    Process.kill('TERM', pid)

    temp = Dir.tmpdir()
    File.readlines("#{temp}/ueberzugpp-#{ENV["USER"]}.log").each do |line|
      puts(line)
    end
  end
end
