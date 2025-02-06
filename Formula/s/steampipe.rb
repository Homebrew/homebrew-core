class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "da82252d369c41509e251e9f914cd922e24977026449982d612a37d81b620bb4"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e8a373e8c218ffe31961fbf998e7692fc5e7fb7ca3e1d1c7e9e1a68f05d75b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f0f404166368f989263ec0a16e905bbbc3e45a26bdfcab1ea627a9e5fdbb29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e8afedda979db3575a560b978443ed3e5027da5e3549016b1d722e66121a588"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e43970da6d2187b20e49929f43eb829beda6f57b9e7757b83905ee4a6113c9b"
    sha256 cellar: :any_skip_relocation, ventura:       "2cb16729f527169cddedcd8d6a70238d39940e2f7ae4c4bea168bfbae661123b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33ae7e4f171908ad3688f3950c2cddbd80684f245c6fbbf87bfd3710f04c8e3e"
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
