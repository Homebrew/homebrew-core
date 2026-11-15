class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "40cf45bb326fae61e06835182ce0987a83de9c823a6c0ea0eb3ef5d7e0344136"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e2f503bb1b8d06f41e551ee4e1543533188da24b4acce4f40bd9d2505aa6b66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e2f503bb1b8d06f41e551ee4e1543533188da24b4acce4f40bd9d2505aa6b66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e2f503bb1b8d06f41e551ee4e1543533188da24b4acce4f40bd9d2505aa6b66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d651f243273e16a1f28fff5eca36eec8cc47afafdea6917ff64023cf141a141"
    sha256 cellar: :any,                 x86_64_linux:      "a77c654c5a58cccc88048d59926805f23422f2519973b40b5256120c193f3cd3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
