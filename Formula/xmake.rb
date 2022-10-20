class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.2/xmake-v2.7.2.tar.gz"
  sha256 "2d1159fd8910cd532b09315cbf7e3c8943df57f2b22952174c8cd04ba0358a14"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a348b7c7b5ac79d4f8745d25496003ffa72afaac5b99310172dc8ed8be31713f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cc4e83733b5dc96230f7dd100644c2919256b5b7607946c0abc7e9b80221f19"
    sha256 cellar: :any_skip_relocation, monterey:       "240628f29904e3668c011f849c7469855de56f33985d177996c990a5db065278"
    sha256 cellar: :any_skip_relocation, big_sur:        "71d58dafc0581b2a229bb55e13ef1566c49f9cb0c3fa8a01e5a741f17eb8b489"
    sha256 cellar: :any_skip_relocation, catalina:       "a66f3a1818097f95d35ff23fc664799fa396aa9d6bff6e4baea083069b98b3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82abed7bca468d1339d59631ac90997b49b520365a27aa44a09165e8735d8481"
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
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && (ENV["HOMEBREW_GITHUB_ACTIONS"])
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
