class S5cmd < Formula
  desc "Parallel S3 and local filesystem execution tool"
  homepage "https://github.com/peak/s5cmd/"
  url "https://github.com/peak/s5cmd/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6910763a7320010aa75fe9ef26f622e440c2bd6de41afdbfd64e78c158ca19d4"
  license "MIT"
  head "https://github.com/peak/s5cmd.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61627603298bb1a3eb5eaea5f87ccadd359fcce806e7d117e793dde778a2b70e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916e4d04783629cfd49481c1f6aa50ea3cde6f77a3083ff0f297e55c73e5bb79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916e4d04783629cfd49481c1f6aa50ea3cde6f77a3083ff0f297e55c73e5bb79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "916e4d04783629cfd49481c1f6aa50ea3cde6f77a3083ff0f297e55c73e5bb79"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c2d0641ad6fcef280e6120b699cd5118d123b797ab6c8106921573146d72070"
    sha256 cellar: :any_skip_relocation, ventura:       "9c2d0641ad6fcef280e6120b699cd5118d123b797ab6c8106921573146d72070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c432ef257a603688321325afb9306286106c6e9fa55cd1d104a743e267ce17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb0bbbf11a900fb389b607b57acbc203a50bff71b0913a66b6308e658913dee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X=github.com/peak/s5cmd/v2/version.Version=#{version}
      -X=github.com/peak/s5cmd/v2/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"s5cmd", "--install-completion")
  end

  test do
    assert_match "no valid providers in chain", shell_output("#{bin}/s5cmd --retry-count 0 ls s3://brewtest 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s5cmd version")
  end
end
