class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org/"
  url "https://github.com/svent/sift/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8830db8aa7d34445eee66a5817127919040531c5ade186b909655ef274c3e4ce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "655e72bea4067d0efcb64e7a30567f731f5da7000dada2108e23d5258cfde003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "655e72bea4067d0efcb64e7a30567f731f5da7000dada2108e23d5258cfde003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "655e72bea4067d0efcb64e7a30567f731f5da7000dada2108e23d5258cfde003"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf4c21ca183eea4c5d7031685975c760e412846d86d342330341bf95a496088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb32c37bf0037c1ebe9102241235e991670c70c3fcd1bb58c03660a01a09b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04005aa704e77c1fa17c74460f034c5d4fc5de4f0616a9fc89c3dc062e361cf9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.txt").write("where is foo\n")
    assert_match "where is foo", shell_output("#{bin}/sift foo #{testpath}")
  end
end
