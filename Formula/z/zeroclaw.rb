class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "08e3d503f6e6903ac2c52f46424ae03b279c17875a7f5dc0a06093890bd7fe7b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d11486eb0bbd37d6418262c4208b4c4201e4d70b01538982dc62a6f5ab4fa274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ac1c6ece3724351c81ac36dca86b425328eb55bd57290c171c10845c199b760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58864fe93a4762a2a302b2880204d7a05d47bab1a21a59964b1517f086e9da6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c9e83301b4c621ea03ea5270a6b740affeb7f9e1f2383b7f13acdb32d0d9d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "370e5d1f51f62fca84de4f52d344b6b2e00c96f9ccbc970fd28c714baa1c57e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6805e761c21d9e57cde89818ba43e80e9ee9bcf666b79e6c81fab9a0753ce7cf"
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
