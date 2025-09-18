class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.7",
      revision: "a7d1c49d0884a64f9e0fbe0b0ca39194f1b426ce"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4a1f6d49dc9533cc92f8ea183bcc0c1f0710b41ce821b76b992fbfb44d286b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d40abcef42ba362fedbd40ca49a894f4a3febc1558853377981017f0f94af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98adb3a338691956cfbb8b2d45fdb3980d89fd73a330874aa8fdd052d7bd032d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cc8647a2b43bce12726ee77b6c58a0d3933aac1d0788beaf44e46386918ae78"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a03d2eb6a505d875fa15b01ab238da82f15d5ff8db27c76313114a38b75ed5"
    sha256 cellar: :any_skip_relocation, ventura:       "48fdb49656881ebc045082610c5fefb60dbfa0d7794a7a7b61c08a42f8ca3079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a781b08c4409441e73e117d9f99c2b6bd90447f8a4e8a1428c7c41428c6f5915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b01db6d5028c41618514ee7340dae9edce7cd2ac383d45876d0d34d559f046"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
