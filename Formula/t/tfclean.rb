class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "1c0fa4a4995a9fe51d4d43dadb5e50579a354e3614a3a674cb009b4c00f3264e"
  license "MIT"
  head "https://github.com/takaishi/tfclean.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07fad1bc85357498c303eb9965a521ce57869f5caf9bb967178278d5b2086aed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07fad1bc85357498c303eb9965a521ce57869f5caf9bb967178278d5b2086aed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07fad1bc85357498c303eb9965a521ce57869f5caf9bb967178278d5b2086aed"
    sha256 cellar: :any_skip_relocation, sonoma:        "abfce71e4e7b4741a3d47647f7968173cceac59c36f00d58cb35ba24ddc2a030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45aa2f693a0b21c4cbc52cf9fe420f333c5b9252c8c9d7d4a72b4d8a6a218504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7e1f6778001d75a5ae3afab242fe42a1614908145034e6367ef896c15f5237"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/takaishi/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean.Revision=#{tap.user}
      -X github.com/takaishi/tfclean/cmd/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean/cmd/tfclean.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfclean"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfclean --version")

    # https://github.com/opentofu/opentofu/blob/main/internal/command/e2etest/testdata/tf-provider/test.tfstate
    (testpath/"test.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "0.13.0",
        "serial": 1,
        "lineage": "8fab7b5a-511c-d586-988e-250f99c8feb4",
        "outputs": {
          "out": {
            "value": "test",
            "type": "string"
          }
        },
        "resources": []
      }
    EOS

    system bin/"tfclean", testpath, "--tfstate=#{testpath}/test.tfstate"
  end
end
