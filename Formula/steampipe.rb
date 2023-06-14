class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.6.tar.gz"
  sha256 "50038a3dac08577fa578c82c2d5ac9f1cb151c393a3146daae47c968b13723a0"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d326c8f20bebec71181e893570118af5d8be832bcb8960fa9b3083bc0b8aa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b36372b02775f2983d9416ab0a0b437c0c870119836ea5e962ed5303a0b99157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "215cdcd574bd7de0edbbb6be534d7886b063ccdab879acbfaa445ec969cb60ba"
    sha256 cellar: :any_skip_relocation, ventura:        "1baee4422379d68fd95c8102b2578e1c1fbe802207b4164152a39184f2ea5b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "2d0a95a067f378c654579bff1cbdc6817709497d77e5273a01f00d607c4c1d7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c5802954ae5a1d645aed1792618ccfdf36b09d8b0a3f5824c19f030782e5814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b34086cc13cd403637cbee39c9565fafcb15623988331a1027a056564ac6a60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
