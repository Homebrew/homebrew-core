class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "279c0872cc4513bf1aed24cc8c0c4e2db3f79445f0199c3dd245a6761371624a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f9e98ce24241e42b68261a8369158e552fc4cf7d0fd01c83a49438bf282a039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc8bbc5fd249a087d22328b6f1448513b0581e16e9a6e53bb407556dcd074ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5622cd2479bdbc645d060f5d9b62abe57084664a3883dfb5c9a3af0f0e7b2b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c92b485e2f79c4176f832a6e07a65ca8c7ff24e5fded7e212ce28d3f98610f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2144e9f8d5b062c5884e83ad8cb7904de304fb63cc5806c83d4b0d722daa7979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c228497bc19540e0f06c3e735fce94f14399761127435248bce7a201a32c444"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
