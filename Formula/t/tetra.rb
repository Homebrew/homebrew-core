class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "d4de499f97899855329b5ab8d7fc9fed5be349abd6e45b673c70554e4918bd2a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4ca71b33acc547180c627c854f407eb3906d4ff30f60b2501d04b9d1c7eb847"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19de6f1783d1d9b2e33860c172d033a5abd4329969ad880633816687e08f1403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8362b1a39aed776aceac2caeedd170eed45931c4ee281e5c37499357afece3a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5d3eaa89db45b7578beeb8045fe2368089f945f8bce6878c7d0f2c300df8f138"
    sha256 cellar: :any_skip_relocation, sonoma:            "6ed24fa9479f2265d4b1f735193b67d4ceb378621b48ad776a7e121fe8a6f0db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40bdd8a674cf61b2775599e494f8d1a04f7ba8b5daf4649e764940868599a971"
    sha256 cellar: :any,                 x86_64_linux:      "4b293c3e5579cf7eb19f4b44b5c34e60d894bc6d98a142d26e919ddaae65be5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", shell_parameter_format: :cobra)
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
