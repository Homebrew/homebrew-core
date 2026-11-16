class Sping < Formula
  desc "Real-time connectivity monitor with network diagnostics"
  homepage "https://github.com/LambdaBytes/sping"
  url "https://github.com/LambdaBytes/sping/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "e12d45373ca42c3af9adb63370b3a53881aef62bb80990a002cf8da566e957be"
  license "MIT"
  head "https://github.com/LambdaBytes/sping.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "668696d209b033797a618726829eefe83e5f68a7f1294bed71376f895bdd863a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f090e9863eb20f6bb80a44b5081761fefbb9a4bd082a0d3396c6df39eaca7335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17ea27ea61586226517c6b361936f5f665a677ecaac7e611779969a7e354df7b"
    sha256 cellar: :any,                 arm64_linux:       "20c69ba9fc648289f4198aaddb1bc704dfebc34a00d18478282b73ccb1a1e726"
    sha256 cellar: :any,                 x86_64_linux:      "3c31573cbfbe4133c8282d7c6c12d37a8ee37ee3dc55920d3d08bc642a5497c6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["SPING_ASSETS_DIR"] = buildpath/"assets"
    system "cargo", "install", *std_cargo_args
    man1.install "assets/man/sping.1"
    bash_completion.install "assets/completions/sping.bash" => "sping"
    fish_completion.install "assets/completions/sping.fish"
    zsh_completion.install "assets/completions/_sping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sping --version")

    (testpath/"targets").write "# No targets configured\n"
    output = shell_output("#{bin}/sping --batch #{testpath}/targets 2>&1", 2)
    assert_match "contains no targets", output

    output = shell_output("#{bin}/sping 127.0.0.1 --source invalid 2>&1", 2)
    assert_match "invalid source IP address: 'invalid'", output
  end
end
