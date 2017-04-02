class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.1.3.tar.gz"
  sha256 "e84031bed87c052944d0e590aba44087cee836eec0ef797363c4172361a81f6b"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e98f695e40d55d1192dc05d49260877f2312fe9b71d49fa9ee4ffa5bba91ade3" => :sierra
    sha256 "e98f695e40d55d1192dc05d49260877f2312fe9b71d49fa9ee4ffa5bba91ade3" => :el_capitan
    sha256 "3b812e8aa3cad37ea4c6c770b68a60c31c85c48540fdea65a180f3a20f36228e" => :yosemite
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
