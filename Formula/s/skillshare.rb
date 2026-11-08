class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "84b35c83e25db0b96c4994d080c8ec1f6743eb88df22c1171e8c38678e4cec28"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4bc1cb9a7001e73b5705a7079877cc73ef07e9a544480cf551ca294fd5365baf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4bc1cb9a7001e73b5705a7079877cc73ef07e9a544480cf551ca294fd5365baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4bc1cb9a7001e73b5705a7079877cc73ef07e9a544480cf551ca294fd5365baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb536a1fe675c37128fc2430dbea69ea812d1d9a861027813cc44717d9601f87"
    sha256 cellar: :any,                 x86_64_linux:      "02d73545eaa02c56c9a6ed1d1cc3d6751976ff7f754613fa53d904289c08dbb9"
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
