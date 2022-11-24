class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "e1d0f23036cac61d6c57c75ce03c13be99491f58cae1ef8d6ffc0d4e31aead62"
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
