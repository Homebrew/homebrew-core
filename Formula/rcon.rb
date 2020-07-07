class Rcon < Formula
  desc "Source RCON client for shell"
  homepage "https://github.com/n0la/rcon"
  url "https://github.com/n0la/rcon/archive/0.5.tar.gz"
  sha256 "28155fca4de607e7ea7101985178aa7f29ea9de624760e4cbcd2746f7f7f6e65"
  license "BSD-2-Clause"
  head "https://github.com/n0la/rcon.git"

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "cmake", ".", "-DINSTALL_BASH_COMPLETION=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "No host and/or port specified", shell_output("#{bin}/rcon 2>&1", 1).chomp
  end
end
