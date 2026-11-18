class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.12.tar.gz"
  sha256 "645afe9eb5c27e4cdd3a64e887e6a86c7de7c38d0a544cb23494ad00ced963b4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63404e159218e7a9e22f5b3c7e6aa220e3eda3898742825494191860dea731b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63404e159218e7a9e22f5b3c7e6aa220e3eda3898742825494191860dea731b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63404e159218e7a9e22f5b3c7e6aa220e3eda3898742825494191860dea731b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6a2eb9b6030ea4b7f21e02f0e60cec2d7d7f70042debe5b5521ac78d19aeb2c"
    sha256 cellar: :any,                 x86_64_linux:      "057469df6bd0950bf990354710b794068c0d8769757a54af788be0f086acbfce"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
