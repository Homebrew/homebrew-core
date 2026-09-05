class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.96.0.tar.gz"
  sha256 "a51c9b1e714ce47389d6a78447a432298b38af8487ffea247cbb92e3ec83c942"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f84ce6fe6d406c2952bc305edfab3a0df25e4faaafbacc8468742495843285a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e60772e12558e92dcd31d797250c6e2cfe723214b2a671f8e7d7709d4f4a42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019bc0c600478d19999e75202d199637dabb9d5492030d910d6620dc130316d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235803c857fea2399a6bf9df8988764cdeb5eee7387cb5c3c1694df470fbc10b"
    sha256 cellar: :any,                 x86_64_linux:  "0cce8e04fcd68fd5912b12bd10511b6efa56fe2cf0f4ff547290d2b570357a05"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
