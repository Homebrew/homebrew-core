class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5630918983982e37fa07151ed5969dbc5e0c3de9670abc6381b5d689d979bc2a"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11fcfd76cb1cff0c31a56f403bb0b62af2f3b44242a293d48a2a7d3ed22339ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7081beb9bc4b9534e9542fc7e050bf166c357c022aa5bc7aa140777f7ca87a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7111ac3555882cec7c361ac5b57d6132f8141ba521fee74283d92c3015b41c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf9584882d0ed5b27781d8ecf4e0a68390edf72aa3bc7d07615f47f4a34f376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7411a5e9c6b953130ed5b612094e590964134ca981c4d24587ff4dbbda608b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a733e4e2be6b588dfab56dade100b53d0c439e5fddd404c545ce2c4430efd5f"
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
