class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.7.0.tar.gz"
  sha256 "e9ae7e8f0ac9dbb024dd2aaf8a2f5fa9167bc81262787d7edcafcc0fd300c008"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bea66f2f424e7d4d5ca7bc8a43f4f972e2d7fa0f7e96d6a529ddd9c7ec056941"
    sha256 cellar: :any,                 arm64_big_sur:  "ea1ace82500b5f2cd0d8a9c7ce613246a054e7523991c90227caf76dfc5c2ad1"
    sha256 cellar: :any,                 monterey:       "f4c691f11e4898193a2c9a203a3e3ed8bb543f719131f4de89aa43e762666662"
    sha256 cellar: :any,                 big_sur:        "a8e57a37ac0645beb8672becca7a14e6d7559ba7270e171870454fb7ada91a6c"
    sha256 cellar: :any,                 catalina:       "726a11a98a2756256c383072fa52f469dbd767e8fbe25eb0283dd1d8e1812c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e37b1849f9c60215c701bcd6c256955c96b4edb62a866b9d6c678ac105b0ec"
  end

  depends_on "rust" => :build
  depends_on "curl"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
