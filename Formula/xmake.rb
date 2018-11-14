class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/tboox/xmake/archive/v2.2.2.tar.gz"
  sha256 "f3959cf806149f7cd684e28068ff5c44dec69cb2fa6d1a8b60a6ede7f2cf8b27"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f37ff6d23755f0a5bf6d869a567fe642a9943e27ce785146f0b74f159556447d" => :mojave
    sha256 "aaa8b884fa6b54243c2a342200f29e6d9dc5782480936b384bcba525ea1e30bc" => :high_sierra
    sha256 "a7758bd8f49b82790e272259a2e49fbe17f50689fe772043a5c5208128b4af9c" => :sierra
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
