class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.2/xmake-v3.0.2.tar.gz"
  sha256 "a89665b6685ea4b0dffc6d9f92eb15e9ee602fdfac0d27cee5632605124593e3"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83c50417dcb392c7cb279f11c1b7f5666fb12ecbd4741401f0f17364a76f470b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a11640d92d9a1c6d6251a35088965b797ad873a9d20db588f42e06fb25e2632e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "678728a217a162b6aa0035d91d108932c272b8f622a3b7f3d8d78a157dacbe20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ad8bcb5f02fee86ba758a3ca42339963d5422229bc99b18e4d43dd7511010cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e38847c1a7bc3bc2998dc28617e916dc7d8121699578f644d88dd6fbe88ca2bf"
    sha256 cellar: :any_skip_relocation, ventura:       "4c4118a8435a6a4ba8d05127095a19310f8a9b03bf81122698b1ac1e77da5293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec23df130c08de1f361e291178ed2f0413bf2dd36de653bd1deabbd40969bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50c53e5002fd2db67115266f52e387b3fc8943cacac8f2a7e04aa9ebe45b286c"
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
