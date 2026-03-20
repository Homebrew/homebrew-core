class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "dcbde3f1fa438bf0640b4ce71c6a34bdb889a4080945a428f3804136b091ff0d"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d71e8de79941dbae4d3c6c67252e0fdda2e7dcd17ff94aa8f666080f5be1ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a72311914c3062fdc936541b295a7e2edced7d0d8c0ab8277bbd81c652dafe41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e730f33db6882cd74ac46eaa680523dc3bc0b98dd312b4b825d81dc369d0f931"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e6720265404bdbae626b50fc303fc1baffac23fa0e077ca419b308af5e4010a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a34ed171a2ca4088543d6b80965664f1815812b97ad1beb82896be1a65ca53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55987709cb69431e75f9c62e3f223dde0ec8c2ccacfe77728f699cd065f90532"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end
