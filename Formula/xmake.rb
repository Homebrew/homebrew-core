class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.7.tar.gz"
  sha256 "6ea4fb5f9ff5b55b2da09c1efe0c66cc9a6f3146c4c3b3a7594dd9973c121b7d"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5c5f60342a69f67df6677430b1fe8c510db61380a0e3b54ed2e3ac68bf70c2f" => :high_sierra
    sha256 "eb544a2e89f167ccde77eb456fe0a6af0d11364a0e6f5543a366fab3f92335b6" => :sierra
    sha256 "6afca5097e3718b9c8efa55c54dec7241a0be7b45405ca668db432959038a248" => :el_capitan
    sha256 "e980cd27838bec8085559305af416cf9f55f059c8e3e74d452d4a89d41523d08" => :yosemite
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
