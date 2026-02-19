class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "2f19e67789febd3c156820f310c6800cb93559bc41e25d258984e502d1e7dcdb"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c722d565b7a1559ff1680d80a0b09fdca34f11d6c6a007c4d0abfa004bcb4be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5738463bf99a6b710089a98f7d1420d31dc8d935709244de8b26e396a9b78bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3384460eff3af25fff356b8e2f013a72739469e0ae9b06c4d39ff1fb76da2871"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72ba4902afb963c259bcbd7b6b26a540a5e94dc9d3d560a24d2cc1e06180201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf4462316d2d1ab28747682d79cd5a855abcfc6ece5456203ea68eb35c3a4faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ab67ab8ac1ba7aeb65364df5bc0a52085f08d5573680fd83ad36554febd963"
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
