class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "4cad722b7a569a05c86ec489b1d5980843ae60ca8db15aa71174c7810378a8ec"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d60bca61406671618ecf94f2d81104882f9dd8db838a70d0c2cd6c0fa46863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d60bca61406671618ecf94f2d81104882f9dd8db838a70d0c2cd6c0fa46863"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88d60bca61406671618ecf94f2d81104882f9dd8db838a70d0c2cd6c0fa46863"
    sha256 cellar: :any_skip_relocation, sonoma:        "788b7ecff02bbff7fa1563a4937999972799361b4a0c49b1ed8545983d6ff989"
    sha256 cellar: :any_skip_relocation, ventura:       "788b7ecff02bbff7fa1563a4937999972799361b4a0c49b1ed8545983d6ff989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b15af30edec238edf607c38a95bd45249cdd6f48f30ab33bdd0a9c2ae2da956"
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
