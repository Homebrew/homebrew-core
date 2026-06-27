class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "6dc92c70536c7452af982480e78829a73e87fec43b9fa205784a4bfbd9a97dc9"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a62bd8ce224eac85d05c85fa0bf6531e4320c304e6b2e4bab2b4ceb3a24cde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b7a8247eecd154fbd7462f9c4d74e9ebe988966da67def7a8c696a7dee2726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96ae1050a554720cabf8163f45c5d40a85ca43375ea336a0e1c5a3db8e887897"
    sha256 cellar: :any_skip_relocation, sonoma:        "10490f80931bf08484932ca959fd3a943e85110d93a210bcc85161b26891ec4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d16196ca86217fb243bca71f9986526d826cc4de936f1199dce20f601db1eff"
    sha256 cellar: :any,                 x86_64_linux:  "dcdb285a5553f2d482e3bcdbd5d33f0c266d6be0fbd5aa61a39f5d47c2f16eae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end
