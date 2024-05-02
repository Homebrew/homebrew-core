class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.15.tar.gz"
  sha256 "89f12382df947f064bb9bf7d00b065bfc8564520ed4342151f9ce0513f2d3ccb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e595edd16cae1a41f42504b700f933f5b1ec4232ccdb1af4cd89c5926330018f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "854ab8d143c11f67e0df77c6621e27d22a53f8335d1d1d793dc3830121d68c09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d3eb5113532e7783c3d0ecc774332c1b9688a8b990691d71050eebbb1916031"
    sha256 cellar: :any_skip_relocation, sonoma:         "c62b4069d5589f0be59be1bbe47f03c24fca7f3939507e78ebf8cc905fe36f10"
    sha256 cellar: :any_skip_relocation, ventura:        "9d79913129f9302396c23b700ce8f1d0e77aca9eb1c54d5ba4bc748806eb8a2b"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4de62f2515fedffdb3c1445a053da615ac5b387f1a0e800dafd63d5f43dbb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cdea4afedc642dc0072eabf2d968ab8eff2e01f5afefd0e1af0cb55376ef309"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
