class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "710ca9660c11dd6bc33b1f041ae8de848295aabad4478c84092ed65a080059ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5056b02da843e2f5f6ed7f2334316bff8cedc4ae3376034cc95e0cefdee810b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d42f987bcf231b621820fc48b0dd81ef21c18ac1bd19464cb1d2d121b3b06d27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aadb3bae496dfd2922bac2f3d00a57f4a1a783a8d4dd04491394cf9acda00fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "712269391a93695a53fb4b800b5d050c869f2db4a782332def042f76bbbf3447"
    sha256 cellar: :any_skip_relocation, ventura:        "915bb56e7476ec8c51589e0ec16d8e00982d3ea71fb6472d9366461307860e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "5ae12c664f8e3e378f93b23ecee721f3e36b3a5c766a6f20b46afef64335d5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04d1511f61eff9f5defef0231e52430c429de62fa31a14250dab5f4aa23b339"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
