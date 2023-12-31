class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3c08e54e35345a3bc38cc074293180481c5275d19c760c8a1b9df7cb703d4960"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d098643f117ddd4c72579b27871efc193665fc74cd41aaa91b3c4bc4aa0502d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccc3d251630373c10deccd99a03cf52a8d830c5bdcb51d388267f31ef6d2646c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0ca11344dbe1699e1fc78171e90d76ee2e401d8ab0cc1f447f1b554f5086798"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cbbea137540a2eba9caba1df14b6ccb218c8175633b34ff00aa07a658708588"
    sha256 cellar: :any_skip_relocation, ventura:        "ef402bfbc5edde0a37c97839b943b8605403b28b2efcb056888c972a4ea0c5bc"
    sha256 cellar: :any_skip_relocation, monterey:       "314f32c74e08580ac6eb86f9de774f3e85bfcc8c3395f930280ef2ca22363791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6206b9e1f0e40c4aebd0b8058dbabd17dab44648ac645220663a5e331c9b35dd"
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
