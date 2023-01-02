class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.0.tar.gz"
  sha256 "3ac5002419d261b7d9352a621dbe20fada165372444824213b9d46910df7502e"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d799404c3c8e099f02834262cbd376b9bc8423abb5328c1fe40fc75562688d06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfac5a09748de5a7363b81c97cd8d69746bac2402ec3b3c4f201374d6dd48034"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a69420beeec3947cdd16058ee6009820ac8f45c36112200135cc8bb56b0e970"
    sha256 cellar: :any_skip_relocation, ventura:        "61f66e544436132570143259001519850a0f4c795ad4c885ed2658355440f906"
    sha256 cellar: :any_skip_relocation, monterey:       "87cac2ad4287b15b26b4449500191c81db08390faf318e4e3b3288d1b094c767"
    sha256 cellar: :any_skip_relocation, big_sur:        "a83e63f5fa815aae2bfafd067d7728897144b1646504dffb1a70ffba97a79442"
    sha256 cellar: :any_skip_relocation, catalina:       "59b02fa80ed71ae65c0d739d01dac390feb85f5ac574d504be8e9002551a0b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d15675f16c2a89be319e07d20209b3631dca37d856fcbc7faea1a31896455d"
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
