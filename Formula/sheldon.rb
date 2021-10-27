class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.5.tar.gz"
  sha256 "f546eedce0a81aad5972671eded7c743c6abcc812ccf17b610d1b53e9331779e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_monterey: "08102f8cc1f0cd01654dabc1ed4e6d32eda1a33b7536b4cb509947bf54b37a12"
    sha256 cellar: :any, arm64_big_sur:  "7bd0e22ced1bc59e97e78ee02776cca0b09ca2b9c25ba9b5721935e232ce82de"
    sha256 cellar: :any, monterey:       "74caff92854c42393d3a2f6a6eb0a7cc21106a78adea1c63dad6270f2c05e35b"
    sha256 cellar: :any, big_sur:        "b8ac98e5c89001a1b630eeae4aa1705669c6b20feb23e915e357c0851efa4396"
    sha256 cellar: :any, catalina:       "bab3a44ee09b366768dfb129f8cac618a52b7cc2652b83c6278ca614cddb98b3"
    sha256 cellar: :any, mojave:         "9077055e24a48c1ecf49e360b4f74d79ef1334e808578e8de94819037a1172f5"
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
