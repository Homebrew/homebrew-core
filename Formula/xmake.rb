class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.0.3.tar.gz"
  sha256 "80f1e1de8049850419acc964a510f21c456b95f4e22637dce162c54e7244fba2"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "679edb6fab7c93575a746483336f779da659a23ebcfc27a6f7796ed086ef646c" => :el_capitan
    sha256 "e09ba71cf0e65a8d99b684b54de0619b0a36a71ca196ee327044b09186965620" => :yosemite
    sha256 "a8ccb1436118745aa333ec27afba45e1aacc72da9173fa36b5d8825b1ea3057b" => :mavericks
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
