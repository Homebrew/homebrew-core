class Vci < Formula
  desc "VulnCheck command-line tool"
  homepage "https://github.com/vulncheck-oss/cli"
  url "https://github.com/vulncheck-oss/cli/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "d06798ef8321c08835c9370fbe4545ecf0eb5c9b21cbc7db3f6e090ce34fafd7"
  license "Apache-2.0"

  head "https://github.com/vulncheck-oss/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    with_env(
      "VC_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=vulncheck-oss/cli",
    ) do
      system "make", "bin/vci", "manpages"
    end
    bin.install "bin/vci"
    generate_completions_from_executable(bin/"vci", "completion")
  end

  test do
    assert_match "vci version #{version}", shell_output("#{bin}/vci version")
    assert_match "View indices", shell_output("#{bin}/vci indices 2>&1")
    assert_match "Browse or list an index", shell_output("#{bin}/vci index 2>&1")
  end
end
