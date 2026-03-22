class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "b798ea210346474ce7f90dc062e849615abdbfeac1219d88d16bb1da7ce5566b"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed5a10b18aa08bd20327b09cf7ebb6f52f0dabe0120a289848e8e9991c6a6945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5a10b18aa08bd20327b09cf7ebb6f52f0dabe0120a289848e8e9991c6a6945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5a10b18aa08bd20327b09cf7ebb6f52f0dabe0120a289848e8e9991c6a6945"
    sha256 cellar: :any_skip_relocation, sonoma:        "613c7e3a993c485cbe041fe608ff7dc766507689f7408060101806629a5df465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f690ebba1fc834e088305ff8f6047e6e199bff76fb3ac10739ab7e67087d7f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea13aad1351bb0da64fefbc96d3dceb989fe621abd4a19fa5a23d9a1eb8b9ff"
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
