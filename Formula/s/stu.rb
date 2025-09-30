class Stu < Formula
  desc "TUI explorer application for Amazon S3 (AWS S3)"
  homepage "https://github.com/lusingander/stu"
  url "https://github.com/lusingander/stu/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "5d0d7086c974e61698a1a61cef6258ead08abf3b7328a39a7c20491d2261690f"
  license "MIT"
  head "https://github.com/lusingander/stu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89bb0ee5bed4206d13d29014f001efb152efecd6f3650381aca7115b44ce129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd15fda0f289e3fa64d17eb9fd5be7e31bf70124d63912287abf072fe0acd750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "278807db070bfb54437999e70c39fc8f4e2a685b177e771533a58eaf134f5bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1f36f7806d04a7fd7fe4168ce13df0b49fa52818981eedab4256f3751fc504c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b81cb5d9b1dd1333ba2c1e307c90c7cd4b54ea0173f98194ae8aa4e66e53af42"
    sha256 cellar: :any_skip_relocation, ventura:       "d66116812c1f20366feb46da32d95ff726c4de498619d79f48bdd0ab2ce52b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51a97403a207943728f3bd1c744d070e2d067cf83115dfe8aafd7a4fc112635e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea7c8ee176e98e2e17619b225db20efbba3bc2549c98971ae75da41cca1f353"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stu --version")

    output = shell_output("#{bin}/stu s3://test-bucket 2>&1", 2)
    assert_match "error: unexpected argument 's3://test-bucket' found", output
  end
end
