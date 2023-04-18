class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.7.1.tar.gz"
  sha256 "22357b913483232623b8729820e157d826fd94a487a731b372dbdca1138ddf20"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3da53db796890c0ac7f98174008145738e6344f354e8f25370d6e8a5eb90482a"
    sha256 cellar: :any,                 arm64_monterey: "eb6155ac30d1322c493584964ab5b9678724a85c739dd1b9ec91c6b6afc4a1f6"
    sha256 cellar: :any,                 arm64_big_sur:  "ab3bddd34e6be2812e919e497b39cb2df62de780890ccdfc0b18944f3696c30e"
    sha256 cellar: :any,                 ventura:        "c11132d137cc60a285c7e86c88f93d1771e1bc1e93e066ef5c0dd21442e56223"
    sha256 cellar: :any,                 monterey:       "871a65be7e795ae1ca1a0fb72460ad68ebfd1b7d6c80c1c81dac8abe183b0ec3"
    sha256 cellar: :any,                 big_sur:        "690bfbafd4c66f64d31020acf62007d855be91b68db9f09b468080efb7ef2468"
    sha256 cellar: :any,                 catalina:       "e1038bebc73009330146de1fdaaa2d604c356569beb096234cc50ca250e70b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f09eb1d66328065559864f18b453060cda9843c8a98627e1208653bd7c6a61"
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
