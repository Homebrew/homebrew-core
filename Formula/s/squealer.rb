class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "c4be3f6a6dfa926cc50e6f8d780d3af9abbe1ac24ab528dbf9848bc89b63b697"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba32cfb4a7e85c23c6f8662837dd12a8ed2b2b36b62600243f45c18df7ba84f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba32cfb4a7e85c23c6f8662837dd12a8ed2b2b36b62600243f45c18df7ba84f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba32cfb4a7e85c23c6f8662837dd12a8ed2b2b36b62600243f45c18df7ba84f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0abbec834255a9bff97cb798916053c892f986147faaf7d5ac465becb2e328db"
    sha256 cellar: :any_skip_relocation, ventura:       "0abbec834255a9bff97cb798916053c892f986147faaf7d5ac465becb2e328db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dda2adeb9318b7b5c786b084221ade08a917ef2760c5cbd362b8107c0584985"
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
