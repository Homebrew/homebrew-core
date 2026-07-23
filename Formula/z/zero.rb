class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://github.com/Gitlawb/zero/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b4bd2ae45889e4d8e6c3688fa4713baf6bde4f0ecad86b918966752423f99e84"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97f49a90cad68ad0e0678650c113c0a447e8c20738bac49489efca15129d5f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f49a90cad68ad0e0678650c113c0a447e8c20738bac49489efca15129d5f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f49a90cad68ad0e0678650c113c0a447e8c20738bac49489efca15129d5f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb2c64f93a31aab905e52bc662e48c7de9e071176fd21504a782090e8b929573"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cd4674743004ef3f74b1efee2bcddfca20f32212f1551bea41ff99ac6e5d92f"
    sha256 cellar: :any,                 x86_64_linux:  "a0964b5d3da32f2b828c4a1936eb4689f2a165eb717a7f6c42bac318191c1f83"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Gitlawb/zero/internal/cli.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zero"
  end

  test do
    (testpath/"cmd").mkpath
    (testpath/"cmd/main.go").write <<~GO
      package main

      func main() {}
    GO

    assert_match version.to_s, shell_output("#{bin}/zero --version")

    output = shell_output("#{bin}/zero repo-map --max-files 3 --max-depth 2")
    assert_match "Repo map", output
    assert_match "cmd/main.go", output
  end
end
