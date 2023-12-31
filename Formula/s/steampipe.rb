class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "16aa02e84fdd5d6f8e13ee36730e2c412e21c12139cc7a9245267f433c4851db"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a187762946a7c3ff8640d3d7fa91ebf9d7315bdbfdf1a24fdb839f6d7354051a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a261f7ad4f5e845388d89193e37b05c227a6d85142d5a4eea4cf8f1e8f629c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d85daa1c779e162a762d6f6829b53e55f9338a218c702017affaa8d75fd7031"
    sha256 cellar: :any_skip_relocation, sonoma:         "67c6fb573d266283cf7fb101db40765c805883549b6dec5a36f336a66c8dec8e"
    sha256 cellar: :any_skip_relocation, ventura:        "ec5a6ede93b6769bdf2a04925fba6ae2bea26ffef54b2e27d12cef2da56b776b"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac78bc83b69e7338348e775dae5e14325b1d8df3aba0ee80565fb3a7d8cc507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e062229869722babcc04c8983c7fd08a211c5f272bc6007357030eaa1ffd0dd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
