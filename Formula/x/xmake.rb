class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.1.2/xmake-v3.1.2.tar.gz"
  sha256 "0e068e76c66dddd87573a31b77f37c8c4ebe7d50b0fb48d507dcb902c77e6cc4"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d18b4c6199b16c05fdca5d36ee1810335efaa6f78c7936159afaa4bf18b1acd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a21d860c80d371907b99944ba376519f4019cc67a301636b66b14bd59296969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "377cc545e86b9acb40f8e7eb4960c3d6db69b54623ea954fcb506d317a3dfd51"
    sha256 cellar: :any,                 arm64_linux:       "857fa73b5e365a3af60d148e8ff4fcb6f224e8a5bb43419e1b40064f3c75dcbf"
    sha256 cellar: :any,                 x86_64_linux:      "a0df63d6deab7fa214bb390dab4060a76933d837da5e7bd1df3f5e6fa4d9ccf7"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  deny_network_access!

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
