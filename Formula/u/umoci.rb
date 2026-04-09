class Umoci < Formula
  desc "Reference OCI implementation for creating, modifying and inspecting images"
  homepage "https://github.com/opencontainers/umoci"
  url "https://github.com/opencontainers/umoci/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "400a26c5f7ac06e40af907255e0e23407237d950e78e8d7c9043a1ad46da9ae5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829bbd94a1b9c3964d348579e9a28529a4ead9ced1b404c4d4f622605ea62fb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829bbd94a1b9c3964d348579e9a28529a4ead9ced1b404c4d4f622605ea62fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829bbd94a1b9c3964d348579e9a28529a4ead9ced1b404c4d4f622605ea62fb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "72fe058ae9412ed0ce970924c427e99d277fca22c78d04da4b01902b62c3cce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3377df8adcffb0ae679c980d628d88b6e48b72993777edff8c3910808c7d96df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fcda2e6f0a1069ccc89935c14ab9e168f9b183fe99ede1878d444bb8c44db0c"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "gpgme"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/umoci"

    man1.mkpath
    buildpath.glob("doc/man/*.md").each do |f|
      system "go-md2man", "-in", f, "-out", man1/f.basename(".md")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/umoci --version")

    error_message = "invalid image detected"
    assert_match error_message, shell_output("#{bin}/umoci stat --image fake 2>&1", 1)
    assert_match error_message, shell_output("#{bin}/umoci list --layout fake 2>&1", 1)
  end
end
