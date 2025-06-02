class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "02d29561b92110e83596ec93e19c8787b31f4b3211bd0a9d2c384d1b09f74c94"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a136ef60c859adba5e9126d4e30e20270fea4489c9411d190e42008b4f464905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a136ef60c859adba5e9126d4e30e20270fea4489c9411d190e42008b4f464905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a136ef60c859adba5e9126d4e30e20270fea4489c9411d190e42008b4f464905"
    sha256 cellar: :any_skip_relocation, sonoma:        "103f4fe09efa1fe6d2dd13a23014ee6c8540313778ecef73accb195aae853c53"
    sha256 cellar: :any_skip_relocation, ventura:       "103f4fe09efa1fe6d2dd13a23014ee6c8540313778ecef73accb195aae853c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a842627c99794b757fe6046285605c8182c2763202cc34d65bffd3980cf217"
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
