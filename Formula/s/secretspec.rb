class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "041d447acbf1d0a57c73c77addcec069560bc4ee1f87e51a75df41cf0394122f"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6765928fc403aa041531416d73297c04791c4a5d570b82614a6fe730351b1413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c786e4ac762bcf0f846646739abf9d12f6e2ca4d81e4b2d984534313bd7beac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1b006b9ef688e3ab3810a76f107e0ee98ce32e048694c0df2090e5c18561e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c800864a62e9d85ddd24701d6c841b3fb2041c88a8120f2563c07932f059656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "723d1c2d1716fa4810b8da2037b5fc956858919d5e603f89d078ba9a4955816a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6ae7b13d7b41ce04b9e325f949c060f810c1a364690cdc5e8e1f4d12e8f053"
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
