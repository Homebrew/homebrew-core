class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "7d5d9651d4a956d1907937308149757dd620933b1091be3b9959e06fbdf8de6a"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "752ca69cc4d5adcbd64305e4212cd2934e0fbbe283f97b81bcf27af43be2e8e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0356ed7603d81316535c51b907a5a8c3b4ca472ace52d62fc15cb134f2f11ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7bd40a319eaefed1307f27d9fabdcfb576198884d3b9b7d4bd3f05e4805ca6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a156602947639f573d54b3b09d7187ab33a1c79b8a2424ab1a066b74a62d705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b17a462f72390fa352e4d47cbb04f7f2dffb4db0726c9d72fd4da5685e348d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8665e2aea739b37057ddf9adc6bc247c4ec54cae4daf96aa10717e8bf5d3f2a7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
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
