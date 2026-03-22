class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "6f72bb06b57573ee63fec715cd4493ed90d0af0dfeea7478abfde04745d39157"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a909ead38b4e912cdb01422b2de69df0c1e4ec6dca044df587e54ecda98bdfe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fb6cc984f31e20e1d481f5170ba5d0afa80a5eb42c070e3e1e58a0b3c427726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb6cc984f31e20e1d481f5170ba5d0afa80a5eb42c070e3e1e58a0b3c427726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fb6cc984f31e20e1d481f5170ba5d0afa80a5eb42c070e3e1e58a0b3c427726"
    sha256 cellar: :any_skip_relocation, sonoma:        "997f3dbd8f733cb8ac4885f5c1e847167aab98aa2026e2bff412538b5feea54d"
    sha256 cellar: :any_skip_relocation, ventura:       "997f3dbd8f733cb8ac4885f5c1e847167aab98aa2026e2bff412538b5feea54d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87487fc1f259042ccd78e6cf15983308a5f9dd856193fcb59a73f838e9e768ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3424821cc7dd576fa0a9814cf0da0b292b5f754ef8e63485af5f85b7e15233f2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "internal/hclsort/testdata"
  end

  test do
    cp_r pkgshare/"testdata/.", testpath

    assert_empty shell_output("#{bin}/tfsort invalid.tf 2>&1")

    system bin/"tfsort", "valid.tofu"
    assert_equal (testpath/"expected.tofu").read, (testpath/"valid.tofu").read
  end
end
