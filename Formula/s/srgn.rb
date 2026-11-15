class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.14.3.tar.gz"
  sha256 "10b26f3c28b25ab2adcd5a43b4dabf59109f370f60b6e65948fb8c006da49f68"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad1ef4732e87045ce0dcadd96ee930769e0f12d7d216b8f9e94d6e48eb981a56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db362ce0319620f975fdc345de6b70de9b43ae87a9ea7d2b1a557cde9e9dd0ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4ddc812d04334f9b9567d13afbfb9e7ed463ce4e957fdc26b1503889ee9ac72"
    sha256 cellar: :any,                 arm64_linux:       "c0d73b191cce8908e70e65d0f5183ed3f6db29b20f0a636648f1707a66bd2933"
    sha256 cellar: :any,                 x86_64_linux:      "e6b69e2bdaddd485fa29bc68598008f9fb45ddd3f2d196f60f8299a4221bbcb2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", shell_parameter_format: "--completions=")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' -- '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' -- '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
