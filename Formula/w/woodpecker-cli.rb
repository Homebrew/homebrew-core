class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "8aa1ee7dc858cb73cb18db52e8ac9aa68733479e8fdef306166c4dc0806f272a"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94dcfb82534450934af5edac090562febd0d0cc64ca6563a964422cfe83a2ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94dcfb82534450934af5edac090562febd0d0cc64ca6563a964422cfe83a2ab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94dcfb82534450934af5edac090562febd0d0cc64ca6563a964422cfe83a2ab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bf19504d08b8491c982c6df4083c1c53856a1981463c9bc113fa63803c89ef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8e65568292813ba6ea02c5c70dc7cacc8472f8a3a8dd25ead10a38019ae014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551b28a7d94c42c193b23705a8ad1c4378c39acc833e8a6b45e2b09fc020a932"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
