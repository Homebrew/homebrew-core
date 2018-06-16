class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/tboox/xmake/archive/v2.2.1.tar.gz"
  sha256 "c23a38f8747c21268d11a1fce039993cb2ec756698e08962764bc8cff0760b00"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "904f0bff1251d3a968c334343fd204cea0022e82f1744c33efaf69967dae36d5" => :high_sierra
    sha256 "904f0bff1251d3a968c334343fd204cea0022e82f1744c33efaf69967dae36d5" => :sierra
    sha256 "3989ba7511527a7dd11b54ac7395c80a632045fc211d97f1e26b26eebbfbef93" => :el_capitan
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
