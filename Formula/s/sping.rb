class Sping < Formula
  desc "Real-time connectivity monitor with network diagnostics"
  homepage "https://github.com/LambdaBytes/sping"
  url "https://github.com/LambdaBytes/sping/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ba8508109bab003b5d5fd3333f188ab4ecb46a2d281ef78767fbea7c4a6a8ad4"
  license "MIT"
  head "https://github.com/LambdaBytes/sping.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adb925e96c9942a1ae0c733e62b0cde52df56b668ad1a479ccc3f6dead821319"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70ba163ac3bef70a4cefa7d8a6a48316697a6572b6f354f8b4967af0a6e753c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92d99ef7fd3e4f94ecabd399d95774c79339d64f17717edcdbddc057d2c47d6b"
    sha256 cellar: :any,                 arm64_linux:       "99a32251365bee58e27f77de53ff0ea648a8afaaea694a83c0713f20db8f4713"
    sha256 cellar: :any,                 x86_64_linux:      "216ab52ae6cc7a0c4738ddcf811b0854acdcbcedefff9137138d8c128cec7d33"
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
