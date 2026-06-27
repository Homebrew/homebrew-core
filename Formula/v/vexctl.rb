class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "c846b1288f837ebcbebef7817ec450e5b0a4b3d8f7b176717ae6f3198539d991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bc558faeddb53ca3757ebd389f6375fd7496715ad291a55175a4105011a022b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc558faeddb53ca3757ebd389f6375fd7496715ad291a55175a4105011a022b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc558faeddb53ca3757ebd389f6375fd7496715ad291a55175a4105011a022b"
    sha256 cellar: :any_skip_relocation, sonoma:        "49098be7d124647c73f0c51129f3670eba16f80e67f48f00d3d2f9a2c0579d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123462400d6d82312c643e4b8b298df0f1aa96e8086cb2aa9db5b1537184e71c"
    sha256 cellar: :any,                 x86_64_linux:  "e1c377bef98b3a2663c260aac54ef44127c04aedf036153c08e0d2a0c42367ae"
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

    generate_completions_from_executable(bin/"vexctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vexctl version")

    assert_match "Valid Statuses:\n\tnot_affected\n\taffected\n\tfixed\n\tunder_investigation\n",
    shell_output("#{bin}/vexctl list status")
  end
end
