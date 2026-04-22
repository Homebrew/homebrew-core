class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "de1fb907ecf113629233f7e7139d791ad7b91d6c4eae2c523a5c79d4b7fc1825"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa9abb90b0d00a92f0b1905b15e78183e5c1d432b1502330ef7eec4ea032713b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2051bef9fee36a578f98b411ac7450a874a422b6578abd16887e9ddb1c820c37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a9be50d82a56654f822e5bb8f1e71623e24c9c517401675a19218402defbbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee6e5ab29b7a24ed75985ca5759c587485ddf089258a0703e675093180fee17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131128b771efd591cd02b83d91b55f760b8726c7169fb5a2d433f250659991d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e026112604a84d3c576217741e008d9a4090d13a00f4ac9b6c407e2c8682efe5"
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
