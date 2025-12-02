class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "0f929e2aa9778089d33e5bf0506454dea3f6c7c5c57bdfc8aaa7f2a913c1ae1c"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee08b0e3191558c11a527a256b9bf55512b8c0db77c7d8a781440645256f1f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07bccb7c8198940364b3e17d61b5c694b432c98d0f8146b531c6ea01d0e3f54e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d0343594c2aac81d7d46e8c1109affdb94e06eeb279f6adf0cd0c8cb03017ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "8062e411d4268007b2aea15da4f4f74260a1188af30ba4d5ae4116ce2fe16172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0404d53befe719fc4695c0288d88e8f15f2a79f21077a4c566ffaad939788c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35a534c3cebf62a13490b3650a2f35f965522a3a9fcb908c998da6ff7ea7b4c"
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
