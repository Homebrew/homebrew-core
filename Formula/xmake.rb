class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.6.tar.gz"
  sha256 "0f1d88ad7b5c82788fdecd6e77cc7620f8bf70006ca95228bef2cf3fa7616433"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "575f60f49fc49d69f5bf8b6faac4c26fdf2c61d3fd525905082d4e7e7a7b94b6" => :sierra
    sha256 "3e8a439a4e5a1083d6dbc574e96af536e1000b6e81be2fecff9b0be194734160" => :el_capitan
    sha256 "ad6e56db04471a0920dcbb14d6b82440a5947344f330ff137cfaaf270f52cd2b" => :yosemite
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    assert_match "build ok!", pipe_output(bin/"xmake")
  end
end
