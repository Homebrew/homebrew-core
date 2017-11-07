class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.8.tar.gz"
  sha256 "d7bcbec48f60164ffcdf7fe3116b3f05b83ebf94d6d861ee9eaf9f2224e81432"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2496d281a4aa92e353bfbe5d03f8e026d24869a881b795e5d9732f531ba20d00" => :high_sierra
    sha256 "2496d281a4aa92e353bfbe5d03f8e026d24869a881b795e5d9732f531ba20d00" => :sierra
    sha256 "752d4ef4404d364ca1046851abe8d9023dad7143f21539a5fa3ed63f98c1faae" => :el_capitan
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    system bin/"xmake"
    assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
  end
end
