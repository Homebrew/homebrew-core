class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.0/xmake-v3.0.0.tar.gz"
  sha256 "e749c2a902a1b88e6e3b73b78962a6417c9a04f91ce3c6e174a252598f10eb28"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02820b3b2e1a9e9d0c074df82c1c77d452b1b050876b6a088ca1f76980c9d77b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9572407c21f15349e78e019004bd8ccaa221665516bf35203d66525d4af2f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63d8b7959d6a3e859bcc512a1ebc677e98b5963383756c3f03d8b9c8e8433b77"
    sha256 cellar: :any_skip_relocation, sonoma:        "621be190e7b7b2d4c2c71fddc95f2e9d8d4a7e080cb695108b7e0eb13be6c02a"
    sha256 cellar: :any_skip_relocation, ventura:       "cca46e72db34cf8ff9ebaa7f8d7bf68bb08fd41c07c0b9cca663f5fd1ee9d004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46686935aed1c0fd191f7ca627c226b7a4a81914eb25a61fe2f9c0995e74a712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27db85cb66ecf29191866706d21587cca0af5a6ea1f82969cdadca98f8d7faf6"
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
