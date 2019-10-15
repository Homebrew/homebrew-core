class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.2.8/xmake-v2.2.8.tar.gz"
  sha256 "fb8ad4ca5133ca0cc303e57c24afaf00fbdaf7a9d59e1a6e7c4337803926bf29"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3903b56affb942c50fbcdda7eff591382082339ff72ee7b520d15cc7ad362680" => :catalina
    sha256 "1cd0b542c034f5f58d3d42f1c447386817d32d567c5d3dd0d048aa491588dcc9" => :mojave
    sha256 "d744b2bb04f95470246fec7bc911d1013d5509dc8328a540da2a528eb56721ad" => :high_sierra
    sha256 "64bc6143dbd8962490617d14693eff572cae6609d53c7c3ef6f3cac6a7fcef2d" => :sierra
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
