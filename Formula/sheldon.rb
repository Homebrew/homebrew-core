class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://rossmacarthur.github.io/sheldon"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.1.tar.gz"
  sha256 "297b5ad75e7d5b44887ffe19ba6ee8a4ef13d884d4f7e8b482df9fc968ba5bce"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f0322763809b4ebac2a61167e497271878c28c1afd57bf255a2c4e716f5dd83"
    sha256 cellar: :any, big_sur:       "4f9bd308070072f1709954aa3392ac81e54858397cd7b715ea27203a514f9796"
    sha256 cellar: :any, catalina:      "cd9012b81bdb7ea2b371d521d0eea2336346003018b90562a735b0e91694ddb2"
    sha256 cellar: :any, mojave:        "229364c6a60c756bbbd55c6be0ce94af0f8d272b5f6e031ea8a0b6c4341d7d53"
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
