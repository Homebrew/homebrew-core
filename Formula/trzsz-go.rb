class TrzszGo < Formula
  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://github.com/trzsz/trzsz-go/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "a28f57ddab8e1a7b721584eb52116662bc3099562ac261d8f3191c2789eeec48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365bb728f3b80b9453fd1c8901074d62f97630a0cd798fa1d10b9b58687c68c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc5c6c8431df9aa3150fbcbb816cd9e404f0db63a8b65ed47e556ab727b1db4"
    sha256 cellar: :any_skip_relocation, monterey:       "5f18645a783d21f6810833f3d652e1160b626a8e871603de7192b2bc3c785b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "464cdfea213d0dcaa6daa3625af0832213dba0fa5be9df1e9adfb35c761c7064"
    sha256 cellar: :any_skip_relocation, catalina:       "a26d06979d89608e691b1943b96410dd315b3161cb827d893113e1eeeac3afd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc784bdea84bca3eaf7ac6435d624c7950eb8dbab22b91d2cd4e0b49f91ea06b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"trz", "./cmd/trz"
    system "go", "build", "-o", bin/"tsz", "./cmd/tsz"
    system "go", "build", "-o", bin/"trzsz", "./cmd/trzsz"
  end

  test do
    assert_match "trzsz go #{version}", shell_output("#{bin}/trzsz --version")
    assert_match "trz (trzsz) go #{version}", shell_output("#{bin}/trz --version")
    assert_match "tsz (trzsz) go #{version}", shell_output("#{bin}/tsz --version")

    assert_match "executable file not found", shell_output("#{bin}/trzsz cmd_not_exists 2>&1", 255)
    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1", 254)
    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1", 255)
  end
end
