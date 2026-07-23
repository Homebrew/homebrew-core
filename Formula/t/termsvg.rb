class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "035334dce273efe3ff4fcf6eecf0b9facdcb2988403eb9e473659c0c7d0d1c52"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c59d436351d6dcc2f4d434e36d37a97a99abe9addb85da1d9d09c976c4580283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c59d436351d6dcc2f4d434e36d37a97a99abe9addb85da1d9d09c976c4580283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c59d436351d6dcc2f4d434e36d37a97a99abe9addb85da1d9d09c976c4580283"
    sha256 cellar: :any_skip_relocation, sonoma:        "422ef93631effdc5c1a7bed5357c18c6125a0990823308049eff740d1f91746f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9392082eeb10b1f4c0f49d05ec2341bc7e7abd1c81a1a5f98ca1b3c10afbfccd"
    sha256 cellar: :any,                 x86_64_linux:  "8a4ccbee12254ae5c77b6bbbbbc266948f8ca8b4b5c34fa8e4bc359f20cb5799"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 80)
    assert_match "no such file or directory", output
  end
end
