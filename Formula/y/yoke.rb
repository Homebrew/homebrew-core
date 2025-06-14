class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.14.1",
      revision: "121f0cd99cbc833b335b7dec0b8b37dacd7f7ed7"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598c64fb7f6c2e968f0a57f339cb94585c0ae2f9b5db2685443f982b7c87ab9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9296230f2cbfd0604b979a47b1bc20993196803ce8890ac1797af347cc813302"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fcc5dcb51d34bb49a9e1e9bb2ca1d13075e2e2f035346fe21f0686547abb518"
    sha256 cellar: :any_skip_relocation, sonoma:        "a961dd8471a8f2208a7e4574ebd76aece16754192580419909192676154a4b69"
    sha256 cellar: :any_skip_relocation, ventura:       "ce65193f6775dbb715db79a0fe1c7c0eb1e2f3e105f4b86a40ed212a97b43f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a786e537f7d2d4638c6c32c2942374107db79db2b78f77f773347170db2041e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ea77a63f5ca715fd1b402c4bcedeb591a8f6a4edeb54c899f1fdd3b7f0c674"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
