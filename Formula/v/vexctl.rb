class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5a5904448ef1bf11bd8a165d737acc88afd9799618f6583c15cee5d99dd58e17"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d3737e23f7d11f5fe749b5524f7f92a36654592f53caf22e81281ffe6614e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8d3737e23f7d11f5fe749b5524f7f92a36654592f53caf22e81281ffe6614e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8d3737e23f7d11f5fe749b5524f7f92a36654592f53caf22e81281ffe6614e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b46198d549d57cb6d165dd4f4009308fd7ba5373e68ea3e6551ebbb7c3e5d1d"
    sha256 cellar: :any_skip_relocation, ventura:       "cdfd7239a7588664765926a8a5e45dfbc50271017c625701c07d79ab78e67c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9129dd69cff712abe1ada640119124ac040263e31cb8ba1365e6e2edd54b7e5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vexctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vexctl version")

    assert_match "Valid Statuses:\n\tnot_affected\n\taffected\n\tfixed\n\tunder_investigation\n",
    shell_output("#{bin}/vexctl list status")
  end
end
