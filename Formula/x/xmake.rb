class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.8/xmake-v3.0.8.tar.gz"
  sha256 "73da077440d1327e24bc74da2888c418e589dc28966e6e6b5bd6e889721b2d07"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e74c06ea12e5705f6e5ceacf11d4380d637bceea8d8ddbece7e2d20d588e84a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c15ba15bfc1d37cf5045c8de2ebb11749c57b6fc4265708b477af475d12d819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b85532513710c6c9dffb7ae1ef3f1af9f31f0eff862876beadcc9f0c7c955305"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce88159d8f6a8c82a4f04ecfced3147ac2c7345abd0db650692992226fbca71e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1bd1663b62e79f71882b4fc0e7979a7005ff1c86ea0c6388c5539b06861993b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac4e9ebd8355816336aff78e5f66f6e38e0315125f1c460fe925d2ba46318e8"
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
