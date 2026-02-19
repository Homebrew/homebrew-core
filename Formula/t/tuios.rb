class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "722af8631edbf4572d5edc4e067ab8fb5fc5e06cc6052a2f2a292e95c392011c"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e08771c4d69980c52802f937b63cc40ac7c6088c90f5d973aa6f257d9cb0fd0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971610634ce07ba4a83fe37ca448ebfe368dc01edf795fc310ba1c1746cd2c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255d6cebc99d6cbd96e6910b2cf6add2306d9bbab80a7daafc9385ed28aee076"
    sha256 cellar: :any_skip_relocation, sonoma:        "b839698c72b70875aed723ef2c29e8096256db5f189498849b7704cb99f8d9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae813b65158d68c11f04c06e054d0b564d6424d086a6db5cc27aab4a984e237c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0750ab97df56afb8a6a33a08f3cb41bd735e95f81fc51b1eacdb77b8ae6f09"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
