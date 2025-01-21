class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.7/xmake-v2.9.7.tar.gz"
  sha256 "248e496a5a734c89e167f931e2620c0ea4109e7ca913dc1022735129a5ffe9d3"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "290d09dc79c230eb91c50ad11bc777464ebc5dab897fe2f18ac6d3158c116540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1d48bcf2c5e7fd1e54e94409bc981517317152f58b6e3fc4f1ddbde7bef0b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e028c8ad906be3bd9b7a20d637d25318aa6b1c2fa08728f61ee730fc76d3f679"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd9090d5c9446fda2debf6593918a49c914f457162274c6d298c06f88944c307"
    sha256 cellar: :any_skip_relocation, ventura:       "b4701bd3195c8f630a6a5f5540cc56fa892928dccabc82d74d321fdf1cd9cf88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b64a36fdabc39facd74232614473df4c79a62b02df14540e1f72e75a223b117"
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
