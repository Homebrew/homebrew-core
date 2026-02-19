class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.14.tar.gz"
  sha256 "ebcac29df68eec7cfdba1934f7a5efd7bf1f980d4f5652e332cea4250c3c1d5c"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2737db8930a82b39b4146821be945512c353a08cf104ca0409f56a6d40d3db10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77395d416612b9ca09237469d14331561d7a42501bc3d45e3798ff23265303d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff1bd72d7f799a86a3e2a746cf3370a0f6c25f23ff8adee0e4be2a878b66f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb417dd1425630e5e4d87b930370501f15d324fcd0aed004b27fb80326fe957"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8a45fe113c9d69941f1ecdab0a2a04035be6dd6a2be53e8da9efb018d36ed08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd0c9e1597c7b46bcec014cd6c826e4f579e009368773b5a7f51267d137fd5b"
  end

  # unpin go when the 2.0.15 release is out containing https://github.com/syncthing/syncthing/pull/10570
  depends_on "go@1.25" => :build

  def install
    odie "Check if pinning to go@1.25 can be removed" if build.stable? && version > "2.0.15"

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
