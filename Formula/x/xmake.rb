class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.1.0/xmake-v3.1.0.tar.gz"
  sha256 "84aae0926d293f486297dfb63fc4cd802218124c9c91b141f2004dcc4d509fdd"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "548faa9d94bee48c6419f7325d9b6a3ed2c6b789dfcfa55c3c704cfe3a8d4dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7b042c87cdc347dd541ab2e7cd29d57b3b22ba772ec1863696fc872f7d9875e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6831b93ace93c8d97bbd55d3a2c46c4f9ee6f22c8d0543f515035edd74237a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d91acf65694534db2d6458a503e23cc9afcc1b24a9f3fba3a743bfa6135ef4"
    sha256 cellar: :any,                 arm64_linux:   "71bc88716f486e77fe8fb289b891352d60b4c4e355d8f25a01041ef35dfa01ed"
    sha256 cellar: :any,                 x86_64_linux:  "1de20b3b613855b256a112453d03b62a8d71a93bbe41307f33c7069f20737760"
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
