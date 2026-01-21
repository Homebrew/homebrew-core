class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "cdd9235b418f16c69dae3a21b6c43c7ee8e549e116b649f2bd4611796e101c28"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb4479b07886ef47a9674451318495bce5ef336a12f43f095171a79b8da3a8a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ab483eb5024a0202fcef5855a44354d41baaf3020a47913514dd416c6acadf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1ca295d4923084474d397d8b89e02f19faab1c82f7fc560609ecae6b00e6028"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa17aa043ebeb1a494ecf7f82bcdc999e533ebd1a32e50e5302317d9bb30666b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b63219c2d36b70e342e9163b577a3abbee155e8c7c469187fb892c074ceb321b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f02a99d95eb47534d18bcc14be9c448e3704996336d04198d7a2008d9e87bd36"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "--no-browser", "--no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing version")
    system bin/"syncthing", "generate"
  end
end
