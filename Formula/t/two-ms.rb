class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "7653e61105082564f4f382aaf8871bfdbdae05f445620a49fdb3100f88177109"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68374543892a2508b21c7dbafdce5aa47a597b2d00b42449d8afbd5337967d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2701c94b867d58ebd6f088e5dddbad7e9334d4465438569eeac6e971df9713ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08ce2d5bd99ea52593ba5f4152c55bfadf3db9336a4656c5833343c409a22ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "14f1716838cf52e1e9ee1a554c4ae8b2f161d5693b3855a35b95f6cf44582104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d652b9ba806ffa02ddcd69fc58c871c2fee33f0b93f640d28ca6c3b387070042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241994248f67013d69ec89aff3700746d18883b124951f68fab3fbacc08482e0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"2ms"), "main.go"
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
