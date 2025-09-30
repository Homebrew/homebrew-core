class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d30263db6aa7b92282ebf7b8cfad4a3c1a8dd0d2a4480295ae3720b2ea8ffc92"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "881f02e7be25b0ffe0f593d3bbf38995d764c35b6f456ecec08b435978658028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4dd69b9e35173548e777e7a543f34f142476786438e4ce654678f0ed2e956c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af33537c5eda675a767bed836005c6cdaa3da2341eb6c16882db89538bdec7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "430b8a8ad4b0efaafa7093f166301a7d0337157b8c5c024fe62ef3504f287afb"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d789f1e189d0a5b60ed52fef7dce298a03ed209e71cfdfc0c70986fead942f"
    sha256 cellar: :any_skip_relocation, ventura:       "cb363b0cad2c6aa530020115b7c692cd9868f7dd6cfd6d2ff6c1077be75cfe13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76f8eb4ee34b69d7c0e802f15d9051d2a5bce72fc38e3f7d6a9c4f3247a2f26"
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
