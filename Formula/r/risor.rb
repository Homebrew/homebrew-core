class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3253a3e6e6f2916f0fe5f415e170c84e7bfede59e66d45d036d1018c259cba91"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ea463bd6018165919353b3752f6bef780688668e3ca484c3ee1c80dc7b0cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd9613e60e81ef3a223de3f23973e81ec64497138622707242a75ffce3a252c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd3e27a942ab5fe9bc9dfbe75003d44490bd33691278ba5f55658efe021215f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "019a5b1e925b0c126057e4a519afcfe7ca7dd0964aa915244afd6a32c2631e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d83df8d83687d2361145b2608a074a55d369bfddae62bbf05552795f405ba5a7"
    sha256 cellar: :any_skip_relocation, ventura:       "09810c4db8f5ebf475b26af73e69532771b3971574e41a7ed141ba548bfdd069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e62a036bd5fa35ac431d7db4e6be14b36eeae142a9fafdb7c822f2bf5727400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5310ed4dda566a15d859667fe317f44c9242d2d7f12abbd2edde2178d4fbe3ba"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      tags = "aws,k8s,vault"
      system "go", "build", *std_go_args(ldflags:, tags:)
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
    assert_match "module(k8s)", shell_output("#{bin}/risor -c k8s")
    assert_match "module(vault)", shell_output("#{bin}/risor -c vault")
  end
end
