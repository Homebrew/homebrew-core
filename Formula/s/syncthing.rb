class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "75734e6f75395d9d4f5c27a415753b372d5aad5fb9ff08d3a6b50df4b0626133"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbd64302dbe99a5b20f7c50c969df0e4222b09c4774770c2a1d685ceef17cb0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59f16fcbba269bd10f7a40b378b3381e30814c4fad4e14b91c60ddc759fc0c81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a091b092c063375ee795f76fca90de032308d2b31098b34fe69a6d17287022c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c36574e8470722e80334ad73e127a9b91c837872524777ecb97188d99426c7a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "60769dfaa84e5e2c228f0662c09f978dbfd5b3d01fa9801077e16e05aa324c39"
    sha256 cellar: :any_skip_relocation, ventura:        "d0992ec3a77e79de0f496404be30b4ed933d27eb491cfb48f560595801778b49"
    sha256 cellar: :any_skip_relocation, monterey:       "79a1875c874c4181feb3ae967cc7cee7221635e998dde9dd8443a91c89af7738"
    sha256 cellar: :any_skip_relocation, big_sur:        "21014d7f09451c565f7709bd59f503646c9f6682715721a7a4047c65bf326799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670eae849bf328c4b7244e221ad91ad4dd91d6e206971c74b72189ef2e6bab03"
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
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
