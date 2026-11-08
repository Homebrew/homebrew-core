class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "af6c59e523e12aa4eda4f8d54316e8e21e72e1711a8c91f953d8c71e9fb1e908"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2106a40a2ea8d783c1375f7c7a40464758052040bf1b56bc825f393ced682d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0b6bc50c375e59eee2b4c8d8952ae7b6ad640f7d779048d3ffb31abd29354e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3df027db40e6fde9bf459443c608db3680b681c3520d8e84d997157c7bce246"
    sha256 cellar: :any,                 arm64_linux:       "aa5818868f61e5e6774a09740392393262d2f7234ae6480b05a49089e056a106"
    sha256 cellar: :any,                 x86_64_linux:      "51ea984ac71e9d9844a39ace118844ffc10a1b38c8b07a2bb0e9a34b166bc0da"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "extra/tennis.bash" => "tennis"
    zsh_completion.install "extra/_tennis"
    man1.install "extra/tennis.1"
  end

  test do
    (testpath/"scores.csv").write <<~CSV
      name;score
      Alice;42
      Bob;7
    CSV

    output = shell_output("#{bin}/tennis --color off --delimiter ';' --title Scores #{testpath/"scores.csv"}")
    assert_match "Scores", output
    assert_match "Alice", output
    assert_match "42", output
  end
end
