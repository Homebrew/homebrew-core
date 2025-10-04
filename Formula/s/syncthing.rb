class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "2efa307b81e771f9616b1f848274b8550c67400b1a720db3753091c6a201e5a3"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60497c5b6a8aacfb469f73d164019d5f3a96898be6cb758d38edcf9905eac18e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3839a1ae82fd928efdeb03c9caf6029fccf1b002918d956ac16a6951f0f1ae75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71dad3a05834f6e6e625421d91d98f8e192c0d3e7a1c5754b979be790f818805"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6fdb24d0c80a6db131b20b861b3c4b42d5407568e95ce741d71d5474e0614ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "764cdc0185ad446c4490afd373fadd62e7d8ccb2a8ef80f36aabdc3b1cfe75dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4a797cb3ed62d4d502fd318bb112889d50ff4cd9ee58cf5b43842d5d4758a07"
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
