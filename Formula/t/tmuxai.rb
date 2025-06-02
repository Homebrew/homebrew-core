class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "638679407e84f6a95169227e02282d2553307ed1d8aa99f47a6bb59056343fdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05332c2c9d269c9d70b7a12fd58afabbb88c8474b5c730616545e6c23a56d40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a05332c2c9d269c9d70b7a12fd58afabbb88c8474b5c730616545e6c23a56d40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a05332c2c9d269c9d70b7a12fd58afabbb88c8474b5c730616545e6c23a56d40"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c978d0c04e372a18ce76840448ad232a09d4b02e2ff26966c05cfa383bd415"
    sha256 cellar: :any_skip_relocation, ventura:       "18c978d0c04e372a18ce76840448ad232a09d4b02e2ff26966c05cfa383bd415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc285434afbf27c8b15b0bfe2b0ca9b029feb46d0849a2f0b9012d3bebca926"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
