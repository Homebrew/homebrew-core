class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "583ff25cfbc98efbcc4fa04430b9b82efcf5322ab090ee8509d662e540a8bcac"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "531697dfb21c36d06d41c929ae9ca34b114292e400a3de652b7c02ec62230999"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29f4a665cf807083cd5675517aff08210bfc35fb237b3f817804a53ca0fa6a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3455a344547c020e2d88538ab2f5512e16fc97fb5bded88511780c812609d3dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55052826f57ac587264b77ce625b9654c36dd255bed76fdf1abb5d318dfd2c07"
    sha256 cellar: :any_skip_relocation, sonoma:         "b53cab7445d36d3c73cde8fb74a715272277d41b92d4b3434763e39e8e9b5597"
    sha256 cellar: :any_skip_relocation, ventura:        "8f65ffdfc76ebad0abe6e87de5d161681ca7260395541859c494b9d0f85c1be8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e657051d7992f356628c1632717001578f74a9a0805a0b90925516056f100cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dee2f468e4f6cf965ffff7b0ff73686a353bfa45963b2d249994d0dec1b5ad3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce2b9a6dd60bf7b9ad2d8df30e76bc2ebc4165440b5fa368e7fd894f10df448"
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
