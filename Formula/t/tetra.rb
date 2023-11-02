class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "992d9570ee0136586b94cb0096353a1d9852931f3d441a1c52c5c8ac6c8c55ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc68fa231b993be680ab882780bb58df3c8d0cc22ace749ca4047354ef84ada2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a430434c8de32e1038da060e5a4716357da1ea10ef7e88276b1d34e39013c66c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc9141072d854ffd87b907c0d0e39147dabde4d17cf56e1de45a719cac97eee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0570fd884743511ba36cdf172a927133280a4ff1d26e0e69f08ac6f5a247550d"
    sha256 cellar: :any_skip_relocation, ventura:        "ffef824bed11353b51630320534e81d9059c6494b4cb851e0f5aa5ae73b2468b"
    sha256 cellar: :any_skip_relocation, monterey:       "911f0f79bd46afd2e42b01c3e98b9e0dd2db12010eb25d129962c66a22d831aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0b23e891eb7dd14678383faf51f30ce0ce6391794f7e9ac7d4e62bb33116c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
