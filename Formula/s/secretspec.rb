class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "20190d9db8bb9ad088bd62466760cdc3dfa8e9a07f799c1d3566520829a19262"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    system bin/"secretspec", "--version"
  end
end
