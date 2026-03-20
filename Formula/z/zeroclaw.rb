class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c1dcc9aff652f5a150254e8f5ae2a18a6828eed5883a4184d5ed433cc686ad87"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ef29a87f3bbe9b564cb05b1483d42697b338c0b0cca3a35fb69a9b308f9ae97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ed8bf2a612d3bd1bcbb1e2d655ba52de7c702c9074f2d8d6d231401798b5104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be3e10a2c865c985ba96375dc02ffb09fa3c1c1fb6059288afce2b32c23509a"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c6180cc1e84906efcf3313cc47ec830a17e0bb6825fde790eb3230094151b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3cf9f1fa6d4cb085fe983c26b83c777035d1ceb6c686585266908b3a2f93f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c664534aa8d16bc04c8b5b965bd89e3855f84d87e3a9c6ffe1dba267f4fb758"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
