class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "d0818bb3c8d0b38706d1c8916f1e5d1995e0be79b4b6fd646112ac037fea0fb8"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc1bdf76edb8e35363e2d65ee74cf64b6c91739be25f8787173b11fd1fcb124d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc1bdf76edb8e35363e2d65ee74cf64b6c91739be25f8787173b11fd1fcb124d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc1bdf76edb8e35363e2d65ee74cf64b6c91739be25f8787173b11fd1fcb124d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cc1bdf76edb8e35363e2d65ee74cf64b6c91739be25f8787173b11fd1fcb124d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "014bb6b16bc2165b662b5e4c4ce549343e6a50e576660e8c188f28ea6196b819"
    sha256 cellar: :any,                 x86_64_linux:      "cd4d6a60ce620149dabe2d93c82694ba3ff0455b8621d613b71a24f34492af5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
