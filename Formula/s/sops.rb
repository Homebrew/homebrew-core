class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "24b1f23a677535d1e06b63f8b4f7793d4f325b86c5454724fac90f5e73903e26"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96d48df05fde78939944e559b803076d5918423bc1d92b4dba8cfe648b544f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96d48df05fde78939944e559b803076d5918423bc1d92b4dba8cfe648b544f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96d48df05fde78939944e559b803076d5918423bc1d92b4dba8cfe648b544f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d1ab202dec7f4ecbdccd93ac3475bde569c162a561259451897166a07a2ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "745ea76d3a12c43b045f59d087cb7b083f88af9cff9241a1dd69967849895122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f13d7dd2237ef289d34e48f76b46cb1db522b3217b6ccdb6ab869a4b5f1d99"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
