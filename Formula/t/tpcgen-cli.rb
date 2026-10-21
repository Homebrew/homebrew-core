class TpcgenCli < Formula
  desc "Fast TPC-H and TPC-DS data generator"
  homepage "https://github.com/datafusion-contrib/tpcgen-rs"
  url "https://github.com/datafusion-contrib/tpcgen-rs/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "25685eb523fad909b65aa307ef3c585c46c20e48a01f340c65edb6abc4aed029"
  license "Apache-2.0"
  head "https://github.com/datafusion-contrib/tpcgen-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c60b49d4f66863b59698c5496da94ecf70723ba60b16d92c9bc907e11bba396a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b068dd4eacfaaf5e0e5a13e53dc8d2ec7edf6b8447b0761f4a1413fbba54a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6daa26574fa940e1c01ebbc0dbed15b9d58f9d74598d22f12e7cd34926ca7006"
    sha256 cellar: :any,                 arm64_linux:       "72e54af7c6aedfb3e87b794036be68f3d407cee71bb4ba01bcb75b23b522b47d"
    sha256 cellar: :any,                 x86_64_linux:      "e2e26be7bffec78586a5ae4f1a08282fcfda2a41e90709e651a09c7e417e2e65"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tpcgen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpcgen-cli --version")

    system bin/"tpcgen-cli", "tpch", "csv", "--scale-factor", "0.01", "--tables", "nation",
           "--output-dir", testpath
    assert_equal 26, (testpath/"nation.csv").readlines.size

    system bin/"tpcgen-cli", "tpcds", "csv", "--scale-factor", "1", "--tables", "income_band",
           "--output-dir", testpath
    assert_equal 21, (testpath/"income_band.csv").readlines.size
  end
end
