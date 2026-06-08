class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "393b9a6a7df3c8e0216e508a71db1cf800f24ca6981635eefef3d2a4c5c95135"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "531b27c732b666319673eb2b5ce51fbb58fa5f20a0bfed7e47c5f1963c11ae3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b058a6285bc146cb7b88c31f6ccb72f2c871bdb0fca0cfa5fbf3b34c418623a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b35eeaf471809922041f8eeda8dbfd99cad4a3fc421c7fd792d31fb100cdef15"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e7a54e07e7b023803988fc9cf73f3aedbc64efbe5b73eed5ac278407467a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da19792a676cc6848df8918ade798e1e6f2841d0d45c90338b7f1e6f689124aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a48b62084f8f7c3882bb84ae98afc9f6b0a953bbef7a290de9615c23c5ca83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
