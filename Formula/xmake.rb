class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/tboox/xmake/archive/v2.2.1.tar.gz"
  sha256 "c23a38f8747c21268d11a1fce039993cb2ec756698e08962764bc8cff0760b00"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b5fb51a4791b635cd3c905090237cc0b6fcfbc84edaf6004809ce7e9ecc76e5" => :high_sierra
    sha256 "a71a5598db939ab7c082ee7118dc46b101c742596485c94e10ff173eb088dd88" => :sierra
    sha256 "0fef8f8e03381c087fe3cebd00ece1e5637eba38de8d683a9748b1c2aa4eda9d" => :el_capitan
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
