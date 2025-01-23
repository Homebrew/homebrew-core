class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "6446e52cb5ca6584710c3abd9250e0d9708486d2dc2264f7c869ade169876a57"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1341d6c1a075042fd5d03e8a77d36b1ce565c25647eb425585f314f5e2337ac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7a38513b286b32306869d8cd220a8dce874d74301d642f876535ac79276cbe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6292ecf066418fa260cdac90ed34f990f098efe4ad0dced978d184d5e69241"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e953c73fbf0dba085d14abcd76cf171c329d65da543383cb3ff1d0056782c83"
    sha256 cellar: :any_skip_relocation, ventura:       "2631fa753fc2e61faec9f2403eefad78d2902d3f4464fcb1382031e87efb4dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b0d0c1c7f8e8d39613cd92c600e3e2ce9b48da2217c260efa719297b9a81e1"
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
    run [opt_bin/"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
