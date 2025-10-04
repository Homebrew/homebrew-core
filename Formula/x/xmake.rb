class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.3/xmake-v3.0.3.tar.gz"
  sha256 "49d70671f40f28a1d8125df1a2b318cbd44608a26fa3c60587be3a5ad835b0fb"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fe4ed17f870700d33fb837dbc081e087b238886e1e0fc188c8cb80183d2a432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c67f5af2e5da7aa5223ae67291dd1dcda24516af064dbe206c5c01465c31eff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9792833d08ff580576aa8f0d4ce152812b0b52fed5d49c965c70946a34422851"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f439a5f962c3cb248c884dba5f8ef90a206f0bbe30c6914c707ccc5e4be22dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e261efbc688263a83a9f04baaced7217ccad27fc5e127bb408d39d8052b9c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263d381c2c918a7491e2759359cd32650f0322c3de3d626167cff60a4914eb8b"
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
