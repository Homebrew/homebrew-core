class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "b7623bee6e48894171e48b44ba27e3a8111e573f954bbfafe153882f926a9d9d"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe7a6021541bc0166fbcc6552f20fffce1ef9f8348b79e257f584c710ac855b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf567f409cdd4a7a052fade21576b7d885e0e7d76d916087982facb5b028670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1733bd03c9178c24f0ab610c81f106dc1388fdd8e2e19870ae991674af75fd8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bce9335b83d1fef81251e4a9e7e38e69506c8f0de56c266e81e50a4929fa291"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860eadcaefd90098fa4d4f6ce37a2daeef927b01a3e8a5ee9e8e25d2dcf33a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225883961ba0f0ac744110b1c40fbb6a6fe5131ddf8d49d488ad2ea58a62671d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
