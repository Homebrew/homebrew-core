class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.41.4",
      revision: "c7cf8b0b264562b463dd1f8d0ca7a6d1215ef41f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -extldflags -static
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "No packages discovered", shell_output("#{bin}/syft busybox")
    assert_match "alpine-baselayout", shell_output("#{bin}/syft alpine:3.15")

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
