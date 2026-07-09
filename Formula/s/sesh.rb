class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.26.2.tar.gz"
  sha256 "f6bbfd1513332bd5abd4dc5e0b135b8aeac375abb8601f2d7bb9ffe25174f006"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5fb21c1b8c73fe8c5292c00257511469b134ca0b6783523ca20ebf261787bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5fb21c1b8c73fe8c5292c00257511469b134ca0b6783523ca20ebf261787bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5fb21c1b8c73fe8c5292c00257511469b134ca0b6783523ca20ebf261787bcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "624f9a1df204c6fcb47ebe0fb048ee1fb6e96e9932435fb55366135bbe343a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb0923a26ebc45b7e3a987a7f0dec62583ac02695f98715b7ca93dc539005612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4bd03ef75a2f3f64bf7b08fb7795c091bf76b7301d407033530ad29c3f524a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
