class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "c3919e55f49d6a35734bcfc2d3cdc2656dc39c011bf1581cfce839c9e1d3dc20"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    assert_match "steampipe interactive client", shell_output(bin/"steampipe query")
    assert_match "Service is not running", shell_output(bin/"steampipe service status")
    assert_match "steampipe version #{version}", shell_output(bin/"steampipe --version")
  end
end
