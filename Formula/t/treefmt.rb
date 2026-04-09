class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "eb15e4ba4de41909ae5b9fcf7c3763d971deec59683319ebc83ce404fd7c10a3"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2f5a81b67b656811f5322d3bb853f8dd145429746040545df411b3372a1df1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f5a81b67b656811f5322d3bb853f8dd145429746040545df411b3372a1df1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2f5a81b67b656811f5322d3bb853f8dd145429746040545df411b3372a1df1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83cb6292e57374f2bdc7919714c5bfd02e19a01fe4f9803d7a259bb97c44303b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2743a42e91e2b33921bd60f3dfcbc270926e8bb7d65da74b074a858144a81fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4491d304804daa8a2685d0b9120fff7d12230e42a84aa4c261e54db125f5cd6"
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
