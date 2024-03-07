class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.13.tar.gz"
  sha256 "59f28ae66816596afebe04ef22883a01003a81bf167dd2fefbd30d2615e4cf15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f996f4cac18aac70cac4170840d46da7c7c2dc62fda690be1f2249bd799dc01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c309b820fd1e86c0ef039ed90708c5d410ed66a2feffd5cbb8f9c5f5662a6421"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92a7ea64379cb9fee370689e7a0d6d401f442e156ebe33522a6732842fee752"
    sha256 cellar: :any_skip_relocation, sonoma:         "da8681c48375e9adb7655a4cfb65680f5dc82544d8fb827038281efbcaae5650"
    sha256 cellar: :any_skip_relocation, ventura:        "23b7344832444e9a7eb14ad8d9449f4331af173499a8f2f095aebe59265e1388"
    sha256 cellar: :any_skip_relocation, monterey:       "ff7aa231bcb413c9088d755ddecb9e56e24d79b38c42fe6ea02cc56381ddb5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98a681cbb4401a21ef3dbca75bf9bcf4e559ae9730cc26a0e35baeeab753be9"
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
