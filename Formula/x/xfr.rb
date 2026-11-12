class Xfr < Formula
  desc "Modern network bandwidth testing with TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9b974caec05289531ed5e713c0a2041c1f675c66c5be4f2ec4138b5b12e455d6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "529fef810b52517fc9015f2455c97fb6fe7ee448d4befdda08bd4f78b8f05a8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61c3ff4ccc616efcb87282392761dae750832859bcdf59061db36e584fdfdd5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13271f0f279e83e4d2058971cafc79171bfab2a4d85ee003668bf1ebba76567e"
    sha256 cellar: :any,                 arm64_linux:       "01ba72a758da44e073258d8dd9a7ba6a92dd3cd93f7ad6bf458dca371c2f6e2a"
    sha256 cellar: :any,                 x86_64_linux:      "82216e0964ffb932f8c36c69f9b861fe3939e609d06d33a7ce3fe70034933f0d"
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
