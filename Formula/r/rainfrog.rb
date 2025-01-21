class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "ed75a222c625f1d61a52289408b094cd593dd4303573683969c65fbb1d1668c7"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa8f83bf9564d1286f9535b3420c79641348b29f1711694d752fe47e15e151d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f991e5c22f038af8ac428da73a6ea2b33ea1c89ab4f80c161fe10c646b5a1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fa7bd7ef437f83b60c63bb489db236b872685bde07c3d4ca9cfaabf143964e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "28ba9970a68bfdd23f883c2ab6541e18b6f562aaf8008b552b7ca24412dd55bc"
    sha256 cellar: :any_skip_relocation, ventura:       "4f3b4cb6a0423ab6ca5bee923f1672402272eec460894214ace47b827d480728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a702234c4054a7e529591a757e3baa25dbeb39647f06b9eb96daa64f8e533caf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
