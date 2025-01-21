class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "2e06aab9fc4fb4b45be7747eb24aaf07f10fcb19ee706204dbcc2f211bc37053"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f80b2e59ed288954c8e3dd8499dcce7f5c3fd039c16444f3c22070b22ae66d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710d122923d9384afced6dfee1983d5b73597a44c1d4e41523f3361ae5915edd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6605caeb8bd2f0fc43c9fae0da0662e6c2e3009ed4e1ea82c28051228a2e6d81"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b5b91e7fb42315c82719d571a404924fa83c76932da512b844575daad5c9c2"
    sha256 cellar: :any_skip_relocation, ventura:       "834a5f6f63245d0951287eafc8057663f195b22c6f9265e632579a7ac4cd4ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88333e2cda0471014e84b0ef24aa32f0cbed39ccb992181928d937ba06cfe82a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
