class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "a7d37b86fec436d8b8c558a486f21c503565a1dc5b52260498f1c0e8645fad8b"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1e71074986be2d93d968d9b78e3c6d150e89f890af49a7fae49e1e4806cb895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b892e645c5939e0234b07eb2e10d03848448d90d63c9a9305a09741fe11fc23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e55acd5defd591fe274f9c556dfb343c8a50e195a4b1203d5f7cee0c060b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "bec3fcc2f4d7b6579c9f94fb6be266259ac0ca3146fdd9c31ef34288904301c9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1d05727436144e2df5e53685fb2bc3e44d0c37ab26eca8d7db2769ec39f588"
    sha256 cellar: :any_skip_relocation, monterey:       "e64025082676c8e7f8b413a6aa1dc0d2676e4ab41b9655b3649bcd9037c0290e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a4208f112a9698eb8acd528767a468573c68cf99fccb2bb687a6b4c912d07c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenrumney/squealer/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/squealer"
  end

  test do
    system "git", "clone", "https://github.com/owenrumney/woopsie.git"
    output = shell_output("#{bin}/squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end
