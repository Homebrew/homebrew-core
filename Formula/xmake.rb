class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v2.0.1.tar.gz"
  sha256 "88b90a416abb0ccb5b3a910d8361eb9acd07b9b843de3db910948b02f59f2557"
  head "https://github.com/waruqi/xmake.git"

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR =>"#{pkgshare}")
  end

  test do
    touch testpath/"xmake.lua"
    system "#{bin}/xmake"
  end
end
