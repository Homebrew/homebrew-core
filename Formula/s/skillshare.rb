class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "073e99f4144c348f3752fd417fb6e18640fe879fa818bf4a57767cd47d4afb96"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28c89232271c015437ba9cc7298a1d8cfa715e1d365ca55a92eeff63c1cf15f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28c89232271c015437ba9cc7298a1d8cfa715e1d365ca55a92eeff63c1cf15f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28c89232271c015437ba9cc7298a1d8cfa715e1d365ca55a92eeff63c1cf15f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0724344e1f7491ee041c652d7bce6d4165cd64fa929999a21a2ed13d399f9f7"
    sha256 cellar: :any,                 x86_64_linux:      "ece44af01fab8ffca3403faa3c0146a0e7a98493c7333a8475436709d4e8f2c2"
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
