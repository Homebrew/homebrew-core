class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "2784e958e9ce7df8158f0eec26985fe1451bb3ae5add029be02621e761e18d4d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "72a8a7f785ae09bf2fd0e42749e7cacced7c242c1d1c454d9f6ee8558a1fd0ae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "013445da9d0b9daa060b7079a274b4f4dd5c8868515fad1eeb5462a2c05f4ce9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "013445da9d0b9daa060b7079a274b4f4dd5c8868515fad1eeb5462a2c05f4ce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "013445da9d0b9daa060b7079a274b4f4dd5c8868515fad1eeb5462a2c05f4ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4200b2b0df26648cb27b6eb64b0b0ead41c68903a97237708eadad7a6aa44217"
    sha256 cellar: :any,                 x86_64_linux:      "dcf1d668490babcb511f5130615298f61b04e507de687bc10a6e66b8bd6171d2"
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
