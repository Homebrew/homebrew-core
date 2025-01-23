class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "1ca223e92895403600739ab1404dbff8d3a875307060c507ea4e5bc270470d01"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3651f4e45141440f5167ffae34beb6515e53cd8f4395807b9c925ddd74d61ef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3651f4e45141440f5167ffae34beb6515e53cd8f4395807b9c925ddd74d61ef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3651f4e45141440f5167ffae34beb6515e53cd8f4395807b9c925ddd74d61ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "918bfad12c7e32174fb052853bc1b7326baf52b96404ea3e84fc3ae197233223"
    sha256 cellar: :any_skip_relocation, ventura:       "918bfad12c7e32174fb052853bc1b7326baf52b96404ea3e84fc3ae197233223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29123bbc3984845f978dd4880e4a5c08a5090e49098bd02e529e07b8e0fa6d04"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
