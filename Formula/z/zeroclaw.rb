class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "4991b28f10ad82fcdbeda499c7312d41d90e6ae18ee38339c7a3867d3dd80756"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d551d4862e6dff495155bb8bcaa24dc0542c7763b89490462f4d2ebf83c02728"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5587cfcdc862fd75f1fe7ee02213f81cbcfa978bd8f440f53ab43dd65cd741c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e319780b2d33b5d8c444b93756b6feb1b67da8afeae2d7294f771c98ac210c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1f689f9fab53f427ed2deef59051e86dddab4ae0f9e6608b73475b80ddccb5b1"
    sha256 cellar: :any,                 arm64_linux:       "9fcfddc33c13a2d838ea0cfa473399cb65e4821634aeb39f1fbd360fd5fc2356"
    sha256 cellar: :any,                 x86_64_linux:      "d68bdec257f48f1d513a4c26a14a36e2875fef52a7691f1bbef0e9480ba1aceb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "apps/zerocode")
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")
    assert_match version.to_s, shell_output("#{bin}/zerocode --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
