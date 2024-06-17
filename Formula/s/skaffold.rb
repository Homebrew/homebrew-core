class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.12.0",
      revision: "f386e6c552e83c3a9445fe34442aaed8dd381ab3"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ead9c0cd89e845edd8508dae3e631cd634ff6a95939528b86497f3b034b14d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36a7535f03a03ff7ed73bbbb60fa2701e8c8e788d23597e5b62f72f098d5dca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ae83bcece77d8d57dc1ee8966ab98db2784941d56cc4d1686369169de7620f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "adcb8356c34294b2b7a2eb8341d3da14b603e58582bf8c20c98febdf3899e064"
    sha256 cellar: :any_skip_relocation, ventura:        "7ce3d80f48f87c9aa364b1a6cec3c782978f184edc301b5b89a08b522fed90a3"
    sha256 cellar: :any_skip_relocation, monterey:       "2c20cab8d0314d118a936bcdfc14a05ec3f99bcab473412ba0972c2dcad70d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b4b471cd25366021bb63b697b5f13f067061e8c78c6f25f08883b5e010e7db"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
