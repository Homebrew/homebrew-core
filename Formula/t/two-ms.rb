class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "edadf136b6d183b9555064de9d4ed2ea1ed229feabd1be04de17a9dac58d2d57"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a7a32fe3261e9f866a644c1b71e4c192ddd0a139e283758f2592a6b760d481"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f4a852635bfc1f444603db4ec29e8b27d09b26e70b0a6ca16f68f74d44b566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b337bc3d410adda24ba84bba162989ee58df91549dac191014c46b464616aa71"
    sha256 cellar: :any_skip_relocation, sonoma:        "be44091f3118a2fe945d67376c7e0b27d81f40f4d9e71fe179fcde45ce127333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37eced64354abb47ef017074ed871696b22eb54d0acf757d62246f067e71eb88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"2ms"), "main.go"
  end

  test do
    version_output = shell_output("#{bin}/2ms --version 2>&1", 1)
    assert_match version.to_s, version_output

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end
