class Shipable < Formula
  desc "CLI for Shipable app generation, sync, preview, and deployment"
  homepage "https://github.com/niklas-schmidt-dev/shipable-cli"
  url "https://github.com/niklas-schmidt-dev/shipable-cli/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ef580691e3ea5310e1338bb599b138351a660f42d81db529545ad3882c8e2066"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    package = "github.com/niklas-schmidt-dev/shipable-cli/internal/shipablecli"
    ldflags = %W[
      -s -w
      -X #{package}.version=#{version}
      -X #{package}.commit=homebrew
      -X #{package}.buildDate=1970-01-01T00:00:00Z
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/shipable"
  end

  test do
    assert_match "shipable #{version}", shell_output("#{bin}/shipable version")

    project_dir = testpath/"project"
    project_dir.mkpath
    system bin/"shipable", "link", "--project", "proj_homebrew_test", "--dir", project_dir
    assert_match '"projectId": "proj_homebrew_test"', (project_dir/".shipable/project.json").read
  end
end
