class SystemdLsp < Formula
  desc "Language server for systemd unit files"
  homepage "https://github.com/JFryy/systemd-lsp"
  url "https://github.com/JFryy/systemd-lsp/archive/refs/tags/v2026.09.28.tar.gz"
  sha256 "d9fe3b5b81eb6d9363e2ed324909868810ffd2d7a49eb24233524d292db28de8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80b2a768af752d0b2dcbf09ab246fe803234dd7951d599b2cf56c92988fb46ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5c8671d9448c5f65a2c5fc494ec918068d14e029e89c464a320f4119a390a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38a778843744a563d79e221d5378be7b924aa31ef5235bb29c678e3447170abe"
    sha256 cellar: :any,                 arm64_linux:       "e52484569f94df219235476bce330ce71b12f1c55e642065590fe797dfd9b469"
    sha256 cellar: :any,                 x86_64_linux:      "4ff06cef42d1c35dd44172b5c7d73c5d18a50a1841d881742d1a07b4a1e7ba10"
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
