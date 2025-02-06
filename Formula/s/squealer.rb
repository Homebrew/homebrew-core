class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "c5ae55daaa32eb0c2e5300730a93219fc75d596e00004aeea0b1786b6c6427df"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50081b0d169b6faa975833b34c74f764890031bad239b114fcf066a59c75dbb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50081b0d169b6faa975833b34c74f764890031bad239b114fcf066a59c75dbb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50081b0d169b6faa975833b34c74f764890031bad239b114fcf066a59c75dbb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d3b8f4ae415d04bc9c103211c1c6cfba2a766fc9f4c4c6e691bc1c1e7b3f518"
    sha256 cellar: :any_skip_relocation, ventura:       "1d3b8f4ae415d04bc9c103211c1c6cfba2a766fc9f4c4c6e691bc1c1e7b3f518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75d69df2abb34682039711f619b64400a084c9309178b4f2454df72b631b5df"
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
