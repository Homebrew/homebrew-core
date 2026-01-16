class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "a4065f1ca7e820f17c5dc2f8c2a354f58cc994790d74050962ee381a8b3660c0"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63ca6e139eeeeebed915c17e8d50388c191168d2bcc2eba59170a20d4c80c917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c9420fd2c3f26f686a4a96b58e8eb4bbd5cebae93ba080b3bce6a4f8adf699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eb5c12e748dde29bdb1d8b4e9e86fd18446c3ca318433bd9d31d93ca1e5f08d"
    sha256 cellar: :any_skip_relocation, sonoma:        "66672bf1ec0fd3106783953b36c7f5d3aef7262c1336efb7cde1670e6d634875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b0058b12b8bb360d221e1c645b98c61a252c20c48a24459970332a718a493f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4c33110947095111b58decf56d584193e32f46cfb6abcb406a36f8480ef8a1"
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
