class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "b0f8b7857f1859b2ec808a7b2842a6ae65ba9814db3313d30577be10b000d546"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b91513f9725054991330aa54fdbe14d4ccdfbffcf49a22796d87101a9d877905"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06599423af0f80dd35a3d624cc80272a6fa6a1b52b0f0be14afe19e1b66a3692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9482ee07ba0c9f42bd47202b2339824b1bf0f78127572ce031f28dff34f5f56"
    sha256 cellar: :any,                 arm64_linux:       "3401a2f375bd44403f287622a7fbe7750e31ba81635eda8703faa8b4424c9e46"
    sha256 cellar: :any,                 x86_64_linux:      "aad374e95d7f15b012f4ba5fa251a7778155219353ed53b325337aaae86e546d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
