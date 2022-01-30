class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.6.tar.gz"
  sha256 "9d6cdc8fe011c4defe65fbe1507e48a51f8efdeebb5d5b0b39fbde2c73566973"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1090747f162944d0308ca56479203a8b8e35591df181979af778f7aa12a90a79"
    sha256 cellar: :any,                 arm64_big_sur:  "e3e23a06f48f11bf0f574ea59d27e5be6e7c3d50205441bbaa0751664fa71203"
    sha256 cellar: :any,                 monterey:       "ad532042778ad7107d15ffb4139934bf7b9948b11f1e2febf9fab7740c0e2e31"
    sha256 cellar: :any,                 big_sur:        "e8bcf6d734440947f11449e4d8c03a7007eac344f4624089d288483ea907003f"
    sha256 cellar: :any,                 catalina:       "cc233a109dba1ba6392a4d9e0ba5c40a306578a3f12e2c495194d288d1cec4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2aafadbd208e3418c6cbc0aea43de58d9bb07d77d80597bcdd19335d2344f8"
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
    system "#{bin}/sheldon", "--home", testpath, "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
