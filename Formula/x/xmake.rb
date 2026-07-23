class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.9/xmake-v3.0.9.tar.gz"
  sha256 "45335220e83cee7ab9ad9e50900f9e751f32510e204719f89c5866c143ef3a5a"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b55df640fbebae98888708f92e1f89f7cd0539f37f4e31a1aab3919a5e88bc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b1fa6f0f4f1bfd0192f1cb3927432055027f6b4adf0c55fb840b8633ba4c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dea452582d4716c789c0804a40b0a53a86f27dd36d360a052634c6e58d62ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c408dc88db1edf12543e20ed1b56c4629cff6a04406baa44f9ecd65e8cec27c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061f58633aab75b47bd1fd35db4f6b7f522ee39916f5c33015239be3eb1660d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7227751634cc14bc8c5156de305be0eff5e507ddd59815764058e3093997e5c2"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
