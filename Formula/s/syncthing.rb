class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "25976b972457dafbde3d0c606c1801a3acbc33603338f4f6d06bf4c2555178e4"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65d524c8b478a805a335ab861fdf186bb6eadfaa79926612580fcf3f59def3a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3200fcc65cd5fe10be246491bde7cded5bea834bff47143f229619c349f25fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a580260570afc414478fcba5c64872e5a7bb527d66377b4ef28a1f010865dcac"
    sha256 cellar: :any_skip_relocation, sonoma:        "55503bc86a06f475bfcdee29fa3079cb352ea651847d4a62df2cb062cbced061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64e7cbd670e36a8570ae27f23aa27f4529ea87efbe745cdae90d750086be817"
    sha256 cellar: :any,                 x86_64_linux:  "208ddb5ae3a012c5dd67875c00b1d3b19ca1aadcf8eb96989f8583e772f9038d"
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
