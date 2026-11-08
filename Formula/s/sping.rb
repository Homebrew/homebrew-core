class Sping < Formula
  desc "Real-time connectivity monitor with network diagnostics"
  homepage "https://github.com/LambdaBytes/sping"
  url "https://github.com/LambdaBytes/sping/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ba8508109bab003b5d5fd3333f188ab4ecb46a2d281ef78767fbea7c4a6a8ad4"
  license "MIT"
  head "https://github.com/LambdaBytes/sping.git", branch: "main"

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
