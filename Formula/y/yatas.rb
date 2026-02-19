class Yatas < Formula
  desc "Tool to audit AWS/GCP infrastructure for misconfiguration or security issues"
  homepage "https://github.com/padok-team/yatas"
  url "https://github.com/padok-team/yatas/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "d4ecca0180fe9c5447cc13ce9a2b2bdab4a5b977060f5e89b87e9f4ca71d5857"
  license "Apache-2.0"
  head "https://github.com/padok-team/yatas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c90ed32a2ab843066a54f859e89126b50ca638e3db0de2c2fc31d5e0ffd0c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c90ed32a2ab843066a54f859e89126b50ca638e3db0de2c2fc31d5e0ffd0c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c90ed32a2ab843066a54f859e89126b50ca638e3db0de2c2fc31d5e0ffd0c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d27e64aade078931bb577f14a62f6d0917c7388031eb804a21da824319edef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13db6ee8ff945821f55f33129e5b8801c33a2d8a64b718653cc435932e27a857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e88498a68d12b9053006e6c06132ebd5a68cdddf5e3852f6b418771d943afc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"yatas", "--init"
    output = shell_output("#{bin}/yatas --install 2>&1")
    assert_match "failed to refresh cached credentials, no EC2 IMDS role found", output
  end
end
