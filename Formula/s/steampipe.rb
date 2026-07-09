class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "3b9dae922cc9bd1976208d4a32e00e1bee8a6ed099734b019172d8e1f3769f90"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc7bc9b8f0246f7246ec8e73126ccc067c7e9ced10ec1a3ae67f0ac6b0abfd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d9cffe0f9b98d74f1a7673ed2e563c20a935e9ebdb9379ebbbab1d0746e46e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178f3106a2e09db54cb6a624461aa933e8bf0506d48c408bc5c63d131e1635b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ba5533bef28d7ffcbafeae2147277b53c8e0500dfb5ac124d9280191ca2869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff08e4e500473681529f8b7b41e2fd2c232b779380c08b50e5fe4ee4f9ec644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "498d2152b56b3f9278d0af45724ba42b02deee55b0beb1950fe3a53929ee3827"
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
