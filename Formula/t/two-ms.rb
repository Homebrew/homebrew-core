class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "392938f0a55a0fcb30c537700d1b0ba37659d09bd52fac045d49e78248e17868"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9385bc47b9c98604fd59b5a323155a5eaaa84473f2205bb08027ca6ff2a42915"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a285c2a4bd7b242170c2394bbada5c79c3932fee9ae03fc327601abc9fd0b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49166d4b91f30db20cc9544dce3c7476e7e007becea9cab90efad0143a31d7a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d155aea0fcbd875f174b1b8500f289ebac3bc9550e67a6a2e16aca3740d3ff6"
    sha256 cellar: :any,                 x86_64_linux:      "e58f3114e873abda8e22e1a51c3ec97c488b00e3cb1b6ab97f08c543ba822dba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
    generate_completions_from_executable(bin/"2ms", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end
