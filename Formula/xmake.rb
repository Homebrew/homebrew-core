class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.1.2.tar.gz"
  sha256 "7ce889701963b18fe2bcc4efd65d79a5afa7c6bdd4f9053eca0d5c4b0bb1586a"
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
