class SystemdLsp < Formula
  desc "Language server for systemd unit files"
  homepage "https://github.com/JFryy/systemd-lsp"
  url "https://github.com/JFryy/systemd-lsp/archive/refs/tags/v2026.11.02.tar.gz"
  sha256 "2f8e31311e2c8b93a6e02d7be2b81691ffc02066fdf1a6d41529e7b53a4e80aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad9ad0163a5e3e96a7b9d376da549d76f99da6e3c6e9449d823169c2e353067a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51661f31271d52fa7de3bc6f55e81487475a9fd56b900210de455bcd0ea8898f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b51557f8828b4ca34329ffa481d6eabaca23565d9a0b80323ee002541fa59cd1"
    sha256 cellar: :any,                 arm64_linux:       "d63ad88fad826f2c27113350c5be0d957d8c04719b091f3f77f04bf717b032f8"
    sha256 cellar: :any,                 x86_64_linux:      "9ef950bb136689a3922d68a021ce4e29087002c72db5e0414dbceda98076ce47"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.service").write <<~EOS
      [Service]
      ExecTest=brew
    EOS
    assert_match "Unknown directive 'ExecTest' in [Service] section",
      shell_output("#{bin}/systemd-lsp test.service")
  end
end
