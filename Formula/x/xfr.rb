class Xfr < Formula
  desc "Modern network bandwidth testing with TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "fc32357dd5f55d88a6b453b829ff2266efca53871487846c3eb8ae14650a017e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14b1d5e65f6b817a72e9139575ab515169a920043810dded389468a3721de3d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03d1e69213b6e1befc2538df91865049bb91802165c84057f9c01373d1e9bdd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18b070985e2761816c635fc5c5f4c5eaf822b3db36974f66195f465323df8de6"
    sha256 cellar: :any,                 arm64_linux:       "15f72584339bbb3fb306bd94645d3163f5679f4447d5e9361a16e46c8649725d"
    sha256 cellar: :any,                 x86_64_linux:      "43a8d4a208671728c60c309c35bc106f812d1c6f20b5b604a3867c126ee83ef7"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", shell_parameter_format: "--completions=")
    man1.install "docs/xfr.1"
  end

  test do
    ENV["XFR_NO_UPDATE_CHECK"] = "1"
    port = free_port
    pid = spawn bin/"xfr", "serve", "--port", port.to_s, "--no-mdns"
    sleep 1
    output = shell_output("#{bin}/xfr 127.0.0.1 --port #{port} --time 1sec --json")
    assert_operator JSON.parse(output)["bytes_total"], :>, 0
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
