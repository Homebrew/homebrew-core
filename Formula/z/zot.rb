class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.67.tar.gz"
  sha256 "74e5f1be997f29442c431249c6bfccf47a021972c0a12a04de04e7f042c4159c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ae142568358d4b4c2b700afa84647997a7f3b882d4b785e02ad576086efb93a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ae142568358d4b4c2b700afa84647997a7f3b882d4b785e02ad576086efb93a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae142568358d4b4c2b700afa84647997a7f3b882d4b785e02ad576086efb93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6382c99da49a4c397b8695afceca9f932e408b19adce1584f526479dea027f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69357537f17de75f0dad3f0a50dcff2ccacd92afcdbe21aed73cb0ba4152a058"
    sha256 cellar: :any,                 x86_64_linux:  "6f171759f093191c5280ad5e780fca91cd10ec73d13636a0dda3d0a1f27322cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
