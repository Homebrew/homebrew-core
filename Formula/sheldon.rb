class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.5.tar.gz"
  sha256 "f546eedce0a81aad5972671eded7c743c6abcc812ccf17b610d1b53e9331779e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1090747f162944d0308ca56479203a8b8e35591df181979af778f7aa12a90a79"
    sha256 cellar: :any, arm64_big_sur:  "e3e23a06f48f11bf0f574ea59d27e5be6e7c3d50205441bbaa0751664fa71203"
    sha256 cellar: :any, monterey:       "ad532042778ad7107d15ffb4139934bf7b9948b11f1e2febf9fab7740c0e2e31"
    sha256 cellar: :any, big_sur:        "e8bcf6d734440947f11449e4d8c03a7007eac344f4624089d288483ea907003f"
    sha256 cellar: :any, catalina:       "cc233a109dba1ba6392a4d9e0ba5c40a306578a3f12e2c495194d288d1cec4fd"
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
