class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/archive/v2.2.5.tar.gz"
  sha256 "1c7ce3da87c03ce9d6be20b67561421039865c8de87fc4db1f94d934c22aacf4"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eea5a9cde1b7cbdca8f46daee0f3048b4a7d72ee22857112ef03d43457dda47" => :mojave
    sha256 "701bb421654f265f08375a0cacba25cc21cedb0b2c82980dfdf6395354a79ee2" => :high_sierra
    sha256 "4a9a563d5eefaaac6933f0fbfa72ed5ed904da591fc9f77dd914be5f147745ab" => :sierra
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
