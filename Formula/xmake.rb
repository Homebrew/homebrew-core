class Xmake < Formula
  desc "A make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.0.2.tar.gz"
  sha256 "e7a832d407a52a3eb290b5465eb01d1c1d5567eecb6fc627393093b9d6f84bae"
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
