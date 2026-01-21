class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "338157a7a34abf35f7fdb84a1667c49e07d95cd3ef33e8e5f9ce2cb0e55d4647"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a76d59249cfd0a2b3a13e240de2743859cd2efcae738be4a2b868df84f16ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5a76d59249cfd0a2b3a13e240de2743859cd2efcae738be4a2b868df84f16ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5a76d59249cfd0a2b3a13e240de2743859cd2efcae738be4a2b868df84f16ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e4104cebc3b70dc7386c81dcca0100ae2db2faeecaaaa5081411cc25813c082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc85fdc3962251bff000fa1fbac21a1d4735b9427ff3d6c919ce12652057218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593d8629d1bb8d3439b00aabcf405fa61f73c3f83e4705445a79c9835f89d683"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ferama/rospo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"rospo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_path_exists testpath/"identity"
    assert_path_exists testpath/"identity.pub"
  end
end
