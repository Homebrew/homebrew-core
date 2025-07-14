class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "cd4e7eca5958b83e726a81d96ab0d5304fc57c6b336423fc6aeaa90ce43dff83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27e7c9ba5c9919df1663bf381ac44cbcf47e68b6ee65572bc6e2b822d2d8ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27e7c9ba5c9919df1663bf381ac44cbcf47e68b6ee65572bc6e2b822d2d8ddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e27e7c9ba5c9919df1663bf381ac44cbcf47e68b6ee65572bc6e2b822d2d8ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b9618ed0f656423887a9f2bb7d20110034b81c93ce9b1696fe70548e45eb6c"
    sha256 cellar: :any_skip_relocation, ventura:       "56b9618ed0f656423887a9f2bb7d20110034b81c93ce9b1696fe70548e45eb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fccb2d9531d433deddf272d07882be82c3cc84f410f434399bcfcb46d05fb08d"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
