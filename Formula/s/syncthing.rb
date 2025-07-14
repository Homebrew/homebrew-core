class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "1e9eb93be73960f748fe85d2738793b5a11c88e63839254057d4fd86cd4321a3"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aca3cc37688c08a85f974aa304def48d514d3dc7dc4434aff02e476fa9b6cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b81e57ca5484622c846b495b0b6955f5d63a5fae0996305a0e80ccdd76010f40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5187e292870269ff9966b7e3df60d5f649bfd4ab1cd4a4078716a7a8fb0761d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bd895cbc159a76d69d4aea41513a01a6145dc30ea5f48f2e6e90d7f537e5a86"
    sha256 cellar: :any_skip_relocation, ventura:       "0ce6b0a7335b83c4b8f0ac16b8bf114aca508ec0501623664dc3f7db119a7241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb9377ed5d87f8d5fee29860ea4171168b6fac9b01a16a7e4f07f66d01bb8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffe4f34ab698459137219de3d189b8647d366dfdc31b1138d67f166b55d565d"
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
