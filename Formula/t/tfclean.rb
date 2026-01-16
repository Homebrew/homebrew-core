class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "f2a958138b5449a60fad58becb8d66e556646405771c4a2c58c7d6f2db79c3a8"
  license "MIT"
  head "https://github.com/takaishi/tfclean.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df641214713341ef11d2ca48c7be0ca7177a04d520de95fb208b9207686dc575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df641214713341ef11d2ca48c7be0ca7177a04d520de95fb208b9207686dc575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df641214713341ef11d2ca48c7be0ca7177a04d520de95fb208b9207686dc575"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eee9b26fce4debefcd8eaf347bd597e7097cfd11869916137f7c41901bba9a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "440e7542791dcc04e314419c30d04ba7c834c13567d87db73e91a47eb815c9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9769e497d7b7eb81618c7146b0c93a25d730b0f070d2a513b516cc77e05bcb02"
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
