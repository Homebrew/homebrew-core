class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.2/xmake-v2.6.2.tar.gz"
  sha256 "845f4bb50e300f75ed819755702e586614945eddcc74bc1dcef38c5cc107cebf"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bdce80b841e3745b70a0b76fc9d0815f72f78bf16789e1de87221f3633bfd0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bdce80b841e3745b70a0b76fc9d0815f72f78bf16789e1de87221f3633bfd0b"
    sha256 cellar: :any_skip_relocation, monterey:       "76c9c177c438f37e42100e581016a504d69857fd371983c839927aaa82617228"
    sha256 cellar: :any_skip_relocation, big_sur:        "14f3fed3d7fb77715b5d7edaadb04b369c6bcf0e15b3fcf0e46593761c16e7cf"
    sha256 cellar: :any_skip_relocation, catalina:       "28ac6935bcabf82d70acaa38b70eadac05bd1bbe9209436c82e78a1766d06bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620e5d52ed7eb72c7bab501543219aa405841be32f210a979020268601fcbf90"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
