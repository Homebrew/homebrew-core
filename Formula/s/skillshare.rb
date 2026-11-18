class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.12.tar.gz"
  sha256 "645afe9eb5c27e4cdd3a64e887e6a86c7de7c38d0a544cb23494ad00ced963b4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3022076a2270714e7f27a45fd8af57c17ec01e9125333c53a30e3c017965f72b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3022076a2270714e7f27a45fd8af57c17ec01e9125333c53a30e3c017965f72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3022076a2270714e7f27a45fd8af57c17ec01e9125333c53a30e3c017965f72b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b509922d2549355e0445cd9665b972c5660635734b7fef8aa0588aabe4768653"
    sha256 cellar: :any,                 x86_64_linux:      "54bb30bf353845256dde09b8e44b4ae90bb6cbedfeb61cd65d89e6a6e84ca2d7"
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
