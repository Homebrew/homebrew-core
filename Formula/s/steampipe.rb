class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "d7fc30d2fb17fafe35a2cdbec872ff785f9923b76029d5432577c3716c5d8a1c"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8272d88ec8e455794399ac759b4e7e1a4f1cf314684ad3aa5381c353c625b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958bc43ab7e8b8b662872e4332d5f5141b01912e30b47107e56a4df079c4c3b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5d3047b3c57719115478d40e849448348968d07f1aedaba79c889040b56dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae4777ebef90dbdcb4fac8bb1abd28553d6230dcc26adc5d081f20be4185168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7167b295802ebb44ed1cd9d565abc7f40347d39c4ded831e1a6f6bea08387d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b1204a10c9da94ec567fe2f276f9269a7bc2c961bc49a46cc5b83de5b063bb"
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
