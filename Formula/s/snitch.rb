class Snitch < Formula
  desc "Prettier way to inspect network connections"
  homepage "https://github.com/karol-broda/snitch"
  url "https://github.com/karol-broda/snitch/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e0bc3a0b2e4f99d51fcd46217bd863d1ab18c08462fbbf1e875862fb8909c632"
  license "MIT"
  head "https://github.com/karol-broda/snitch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89f1ef41e5f83a56f4fa0b118fd514993fa22dac5b031cb4e6f087e05680e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b586aee24f23eea1ef1078541c07a8aaaca8c72de11d829a11da4898ed4ae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff92a1d1c2a23b803728eb9374b48bf77d8c0fbd2132c35242b32b4f07f73499"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c09b4b77d447461362347c6befc8ebbfa2677c7e271f67dd26dda41a672ef6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2940c863c05cbd97ee356d149049cbecc40357fcb49431e18f68a36663f52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e46445e8ff57282389e49e331dcf5fbff204ce1c32bd1f18b88f457a3dea3298"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karol-broda/snitch/cmd.Version=#{version}
      -X github.com/karol-broda/snitch/cmd.Date=#{time.iso8601}
      -X github.com/karol-broda/snitch/cmd.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"snitch", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snitch version")

    assert_match "TOTAL CONNECTIONS", shell_output("#{bin}/snitch stats")
  end
end
