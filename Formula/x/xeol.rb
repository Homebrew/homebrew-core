class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "c91bc06954b23387d4ae70a6ad20def5dc26492e917d65d2f87a6a05499c2c4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38adea65e107a1ad2a283507252027d29cd2d5402c271b54f269ecce4e97e9fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f37945d0420043d1acaa91c49d0b9323a702bf2fceca35aee5a7b3e9654f42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "705bbdcb7223921e0664b28e9ae640c31b1e2e6cd702a54ed86d7e773b30a0f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b071266e9b25a0590b1c2cf99b735c60369e09790ba7add876eabec734d5e04f"
    sha256 cellar: :any_skip_relocation, ventura:       "0e72f1bfe797f0590d754f7798f8e2c3b5bd856188848a10f0d9d7c3303c9af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5b313606c086c40b416293fc5e04b69939cfdb28f875da4cf6acbc32491f9f"
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
