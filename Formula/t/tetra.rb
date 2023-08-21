class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "99cc4e82367eb4ad12dc5d8b710e609f10e7950280f510ea3884caf814f8bab1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d694725de8b29c3fadce0d5f653add0d01b640a6ba1b631d3d780a5a7d11d61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef7b82f4694e349a77dbff4ba03b37dca5ac4e87495cbda55b90f773ab7551c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5e9c2ec098ca6e865d330332fcf236258b93ad649356a438f5c9cdec4c8b21c"
    sha256 cellar: :any_skip_relocation, ventura:        "5899d07a9b3c2596b5cfd86c7c18fd80ed2b7dfdbd93bc341cf84a38d5458261"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3ad378e8b5de07c7777f1e389d2445d20d338ab2df29df8ca00c9a05a6aa00"
    sha256 cellar: :any_skip_relocation, big_sur:        "73bf29013bb21afad43dee7d0c656b52f552ab9daa79bb2d323fbd896d0487c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff61d5ccd98199d373588b5b4c6d1f8ed6cf11c64789739757a708d267cc6a37"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "cli version: #{version}", shell_output("#{bin}/tetra version --client")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
