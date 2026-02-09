class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c6193dadf1b9bc5a2ef3f04117b0155c4a46fce5bfa26775c80937bcc54ec82f"
  license "Apache-2.0"

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end
