class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.30.6.tar.gz"
  sha256 "570f51e3ef987bc2c81c91cb2b0d1802c5f7d3215dda5e5cbbe3357a2316b4ff"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f59f12ea0015ab6f9fa1fdcdb8dac149fc78bac3eadacecb8513d968d42cde8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f59f12ea0015ab6f9fa1fdcdb8dac149fc78bac3eadacecb8513d968d42cde8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f59f12ea0015ab6f9fa1fdcdb8dac149fc78bac3eadacecb8513d968d42cde8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "022abdd64fd9926a3a6a5d5146ac382fc45306921224aea56d15726e9ccffe99"
    sha256 cellar: :any,                 x86_64_linux:      "2f0ddcf8eb07916137dd25b709c79682e840d0d01aa8e9fdd8aa11a08bae7593"
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
