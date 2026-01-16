class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "c1a431addf696b7fb67d3c144c43293f3c4a7eb40096f7581e55e6525d76b2ea"
  license "Apache-2.0"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f50def689d5a53e1e68649f2e333ef8b396185264496f78551251e44f38d230"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f50def689d5a53e1e68649f2e333ef8b396185264496f78551251e44f38d230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f50def689d5a53e1e68649f2e333ef8b396185264496f78551251e44f38d230"
    sha256 cellar: :any_skip_relocation, sonoma:        "e70ddc65dd49956dbe67cb51bf20294b8e11103831036f7777affd6788a0d375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2f6dfb3492dc035ada3240f826d1541344d4daf7af553834bfc6e0a846c9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5915c6dda915ee730544e936a0a1c7874f2d7638e8e5b3b521da899d13fb90"
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
