class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "d8f28156a6ebfd36b68f5682b34ec7824bf61c3f3a38be64ad22e2fc2620bf44"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78a5017f23e2d4b9fd9312ce1e4e06c09cfb838d47e78cfb02ddb4190acb6b34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78a5017f23e2d4b9fd9312ce1e4e06c09cfb838d47e78cfb02ddb4190acb6b34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a5017f23e2d4b9fd9312ce1e4e06c09cfb838d47e78cfb02ddb4190acb6b34"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d7952151f13e850fa40b03d6ba3f39daa8ec9401735aa91d6cd8e950f880d62"
    sha256 cellar: :any_skip_relocation, ventura:        "0d7952151f13e850fa40b03d6ba3f39daa8ec9401735aa91d6cd8e950f880d62"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7952151f13e850fa40b03d6ba3f39daa8ec9401735aa91d6cd8e950f880d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772a5dfe3e281fc51f6200313fb62b454314bf4978a8fe70ba2026a4fe5af5c4"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -extldflags=-static
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
