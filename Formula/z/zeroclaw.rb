class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e4536eafb945e1a80ce6616197521a0be3267075ac9916be45232ba7448989d9"
  license "Apache-2.0 OR MIT"
  head "https://github.com/zeroclaw-labs/zeroclaw.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f61f1c9b336b2139bbe433dbb15b23435ae7387757886bd914dfb9ff16e30f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd7216773b0071236998998dcf77b5f82def10fbe81cff2018155bed7fa3fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "706f51e08df2a5eb5ad52a45adb7071ee4c4ad5403387634b680eb89b235f494"
    sha256 cellar: :any_skip_relocation, sonoma:        "630614a79ca9bcc1beed4016a66f67a2317f63d9c47fc826a817171240e4573d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e06e587f7fea740d1cd668c03868511ef4d60aeef58677642ed3526329f59fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c403b172342c910cffdecf9f5d879b660e66193e34321a861296cd3b63c39c3"
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
