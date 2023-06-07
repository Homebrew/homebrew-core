class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4d6c08d00f13e5d886bf6800a9c978e578f25bc865fa42ef2f05aae6920c6150"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39cf86d37ec1e54b9d1d582a4283edeb1a23218566fafc89ea3bd74a8e7e0dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39cf86d37ec1e54b9d1d582a4283edeb1a23218566fafc89ea3bd74a8e7e0dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39cf86d37ec1e54b9d1d582a4283edeb1a23218566fafc89ea3bd74a8e7e0dd"
    sha256 cellar: :any_skip_relocation, ventura:        "e4a0e7a634b9efc8b81a12dd16c6ac00bb28506549131d184dfb5881f354b215"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a0e7a634b9efc8b81a12dd16c6ac00bb28506549131d184dfb5881f354b215"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a0e7a634b9efc8b81a12dd16c6ac00bb28506549131d184dfb5881f354b215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4baa3a79527029920fe717ccc7a1b11d8da6093129c7132f8afe45ee3d4f208c"
  end

  depends_on "go" => :build

  # Build patch for OS compatibility, remove in next release
  patch do
    url "https://github.com/cilium/tetragon/commit/09809a686482f83047f44fc921363822893b0967.patch?full_index=1"
    sha256 "46fa04a794d8f0325caeac47ef7e787d3c31e233c4841c4a5f47791cee0c00ef"
  end

  def install
    # remove patched empty files, remove in next release
    rm_f ["cmd/tetra/full_commands.go", "cmd/tetra/standalone_commands.go"]
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "cli version: #{version}", shell_output("#{bin}/tetra version --client")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
