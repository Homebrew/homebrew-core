class SystemdLsp < Formula
  desc "Language server for systemd unit files"
  homepage "https://github.com/JFryy/systemd-lsp"
  url "https://github.com/JFryy/systemd-lsp/archive/refs/tags/v2026.08.03.tar.gz"
  sha256 "4ad6b6cf282cbf197cd1aedd95123a1f17a2a335855010850ede18d6f465814d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2126d8b1e73c6f1b58dc378ffaec479ba39db86ce989fda6797441805995c907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c70928cf27aa61b0dab578b6e00be0e99956a16250d51180cd9ed1d849aa91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c30d81730b689e0dbbefc5983c191ace33f2cb360df198769f98fe69345ffbb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "659f76775eddac294315c5e56710d2157f82273111d215d8b0b4a149f309efcb"
    sha256 cellar: :any,                 arm64_linux:   "ebfa4b0f1e9b5e9bc4280070957557e78588325006a65fd58a38b085c42355f3"
    sha256 cellar: :any,                 x86_64_linux:  "71c484f7bee531281ca02260bb3ac2c10dcbda45dece6d14d67033c754f8eb81"
  end

  depends_on "rust" => :build

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
