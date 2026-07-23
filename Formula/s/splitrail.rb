class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7252ae4d85d77afd42370cdd6d1fae500dbfa74411ff9036e6d2116f4f4d11e1"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4629c106c1cf5f1866bfc246f9e738a4905b1ec5f14e61c9d0439ae0ca85a1b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38e0a3f54151d0b74417f2fcf334e4b54e9656aedfc12156aa4761935b830f06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04cda371341dbbd75b9d90cbc89431eb11b76ff039d174571388f47d6f324147"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e4403384f90c58286b0d9344085c1228338d2491902ffb32b0f58642bbb6e31"
    sha256 cellar: :any,                 arm64_linux:   "565cd61884cafa7c5f79e6fec797fc6dd5bd83bdd745af76ba8725ab49500c45"
    sha256 cellar: :any,                 x86_64_linux:  "88928d722d25a13c3f221037ebf5d81edd908b127f425da1bb069a7a60e14a53"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
