class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "754da072b7313c32caa6abe537b29ed08377a19f191d02a348c85d5600612526"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff81139f0b85218e783f29bd5bd81b478e8bdfd0d38c690bf0b917e8ee6027ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff81139f0b85218e783f29bd5bd81b478e8bdfd0d38c690bf0b917e8ee6027ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff81139f0b85218e783f29bd5bd81b478e8bdfd0d38c690bf0b917e8ee6027ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "132e04cfdf715740683edd89c21f512b8881c2a2914e5fc979af631ea4fbe2b1"
    sha256 cellar: :any,                 x86_64_linux:      "2e2547a314c1b30389259ece1f020d80693852e0869e0bfdb73d25f8cc35ecd8"
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
