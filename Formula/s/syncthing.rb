class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.12.tar.gz"
  sha256 "c6d9a06ee223bad61b83b9212f089b960f495f7e84f3aae46ba207d5b808e1da"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cce25c117c979f05d4cbab1ade76b5786ee710ca70f802841e99701ce0016a60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7ea674407897a8a777470b7992de6d9cd4f6794f7d2ffd00ab4b7474b20eb05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80380bdbe7ecda294b5f99e49a72b2d700c82e7ee0ee6a1fc7930a36db80cc07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cbbe0b8bef9694ac83a936bdb7acd589ecdb92b987a262d81dc8bec114af5a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "25c821cfb420d31b49a75dd7415c633dd8baf71e960d3f1932fb2e4ffe32bd10"
    sha256 cellar: :any_skip_relocation, ventura:        "8d610880c1babbb4f36c63f99202c5fd5273691527878761c0da3e75e3bd3ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "b3cd365ca534f32a8988a0136bc4ca0cec5f6ef91f2bf9a23e3216d03bb434b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b366d823628c1a702bffa5a7816aa39f18ea39b4d2b37a3e607e7d03ebc7236"
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
