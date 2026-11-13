class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.7.tar.gz"
  sha256 "51a8c48267574d7f684fbd6f025625f9dc0df443f999a8beb2dada7015ae09b8"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7defa043bdcee4dc805d4fbdb18505b9376fa0b42a359c4be32e762dcbc4ab66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7defa043bdcee4dc805d4fbdb18505b9376fa0b42a359c4be32e762dcbc4ab66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7defa043bdcee4dc805d4fbdb18505b9376fa0b42a359c4be32e762dcbc4ab66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5279e66bfa33c5eb48001644a768d9387c4e64dd822c7fbbc55e271ff03acbef"
    sha256 cellar: :any,                 x86_64_linux:      "0002569bc36f2a4e5a17930befc04f2d02862d33460ef506144851b4d36e0125"
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
