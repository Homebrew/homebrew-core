class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "0d30d2d2a0faf642f8c13c00b7e71a58e4e72f0c403a0e478caea4ab596ad8f8"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4809f4272a1c9dc27f32dcac005676700f9789a3fc9b17279c974da413e6d63b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4809f4272a1c9dc27f32dcac005676700f9789a3fc9b17279c974da413e6d63b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4809f4272a1c9dc27f32dcac005676700f9789a3fc9b17279c974da413e6d63b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b278a83720783158ae4eb0b8fa5359e4986a6a57b13dc27a4ea2db3ae5b39356"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "756f98d5fb16e983a20024f0528e2b9af9c0240b77c0d448b546c7b62d38c60f"
    sha256 cellar: :any,                 x86_64_linux:  "451b40da459aad9348f2b345699bd943cf60c9406582f672f0c23b48290a7727"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/numtide/treefmt/v2/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end
