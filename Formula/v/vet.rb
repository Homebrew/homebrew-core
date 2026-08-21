class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "5078f963bd1613ad4c0c3d78e1efcb3e8446bc624463a931dc25e29d3d3c524e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b70cbca467b94dd6cc25b59a4cb93cf53f31c8012095e950f0f052a2981f74f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99a017185198f3a604dda2826849350f60263038d2cee50f85fd0221174a9277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bb1dc84fb54fcdebbd2fd5dbe27450bb04154d192edd1d18a23ba062a6c4cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "63a8aa9d9a85d5b7259ea5a91fb1aa5800a81c1e578aeb903a0d4870192308f3"
    sha256 cellar: :any,                 arm64_linux:   "495d9d702f6be13839c8c51f207a9705ef334095fc0f15813670969d3d2b6f11"
    sha256 cellar: :any,                 x86_64_linux:  "431d8a169dc30376ccfb56edb915b1544b7a9388cabbf543d2a4dec6bb4af9e3"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
