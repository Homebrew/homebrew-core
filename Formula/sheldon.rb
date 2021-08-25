class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.4.tar.gz"
  sha256 "9d352f8fd29fcd16545218e46c1524a43549c9049d2dd8d54ddda138d598961a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7bd0e22ced1bc59e97e78ee02776cca0b09ca2b9c25ba9b5721935e232ce82de"
    sha256 cellar: :any, big_sur:       "b8ac98e5c89001a1b630eeae4aa1705669c6b20feb23e915e357c0851efa4396"
    sha256 cellar: :any, catalina:      "bab3a44ee09b366768dfb129f8cac618a52b7cc2652b83c6278ca614cddb98b3"
    sha256 cellar: :any, mojave:        "9077055e24a48c1ecf49e360b4f74d79ef1334e808578e8de94819037a1172f5"
  end

  depends_on "rust" => :build
  depends_on "curl"
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--home", testpath, "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
