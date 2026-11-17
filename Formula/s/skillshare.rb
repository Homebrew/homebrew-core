class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.10.tar.gz"
  sha256 "a6f0476384f2b915e3b631b8d64a82d07d6521d20a54bd440c5c6dda4fea68b3"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf035b63606b9c37812cd87839576d0730523a0b993bf24cb00613ac3119f56f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf035b63606b9c37812cd87839576d0730523a0b993bf24cb00613ac3119f56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf035b63606b9c37812cd87839576d0730523a0b993bf24cb00613ac3119f56f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "553bc46963885d488a9e84cecb21a4f4c10ff925f9b6f3b5be8a786c02f0897c"
    sha256 cellar: :any,                 x86_64_linux:      "f8e264f5a9f6a56b15a5643cd578a325f1843389608e304f4983948fe3a50669"
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
