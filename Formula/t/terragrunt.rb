class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.89.4.tar.gz"
  sha256 "5557737ad6f924e06c8b180cdcc449ec5c80127a57e62f6c3ddc5d40f79ad344"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3964168994ad0580be6377b4d872a49e11eca12a73d468a377dddecf267da9e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3964168994ad0580be6377b4d872a49e11eca12a73d468a377dddecf267da9e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3964168994ad0580be6377b4d872a49e11eca12a73d468a377dddecf267da9e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "47c372b6475af3bbf46f2be67443fc79a5b9e9766d890af3d4018fcf0e95c6b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35aa7f7e7d7c15a2fe4891ea93dafea6dccd6640836c5ef57e472bc03b963037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8298640b811a1ee5a776be922bc0809c78f54afb2d720172c17072d878f34186"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
