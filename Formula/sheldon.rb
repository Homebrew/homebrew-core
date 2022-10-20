class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.7.0.tar.gz"
  sha256 "e9ae7e8f0ac9dbb024dd2aaf8a2f5fa9167bc81262787d7edcafcc0fd300c008"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8a7be6fab6dadd2cd6f4d072f0ebc113892919f9c6fa64b7759ee092de42addc"
    sha256 cellar: :any,                 arm64_big_sur:  "68d5dc7f44ffab14bb8555d9a195d6175e073010116cab98e4200f509d5c6629"
    sha256 cellar: :any,                 monterey:       "d4a608ed171fe09983846c859f4480873bb0caec66888957e912fad9f78f810b"
    sha256 cellar: :any,                 big_sur:        "5e3eab027fee87b1e6a7e824163742626d85668e879744c1fc5b0caa3e442cde"
    sha256 cellar: :any,                 catalina:       "a6daaf583e641b404a543a2b9836c818848fda45db14a3b4676ec6ce4987b21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9556854912206d55a0e3b778d166b60f1b0e870f3ccec75ca8bb3ea2285aab60"
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
