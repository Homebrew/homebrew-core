class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "7e86e88b1626b3ba21e89e62793431ea240d27335c084920d504a64f6c34dfc6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aa5255d23cb385a240c4f1c926666f79454c6c115e209b05e836a5b4a609e37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4e5e264d8dfda9603695dab7950efb424b7019a08ef3f5ad33ee6326174ab26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61737da5cc3046a6819e8b942fa0917dfc69ee72df2ca5ded148231fc6d815b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bb4b88fe1a57047bbbff761013ddc71f7d1927fedc61e56b32423da8a3bc310"
    sha256 cellar: :any_skip_relocation, ventura:        "f40ff337fd036ea005d381e3fccca0bf13b7fc93f5c6a55144b5e0d3c81a59d1"
    sha256 cellar: :any_skip_relocation, monterey:       "69418a5bdf96053fc7c5bdd7a264c94bec34cc3e1c2452325582b27656313d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5376fa3a46b3a15f2a46a133956f5bb9682c5ad8be93242cfe61305bcf552f53"
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
