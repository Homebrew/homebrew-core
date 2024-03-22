class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "a058c74be956bbf0c1e9b369b2cfdd18acf0800059a5a0122deb74085d7e2795"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e10093a772175510e9a7a820df26788009d9a839f62cc9bea6b5c4b399c56e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e17fa54b9b965edd9188d57ae7247617b06d2e040536c9c599f05a6eb3e6065"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd5686c3c0919eb8a94e79dc474c5184725d7347e31461b2740cc619d55a595"
    sha256 cellar: :any_skip_relocation, sonoma:         "68967a779ce719959a7e1b596e2feb7d0e0251161ab498650f249990d671f8b0"
    sha256 cellar: :any_skip_relocation, ventura:        "f1bfe3fcdba3e267603f0b62636f0eb30d903c0d952f7caeb6ec6bd4e461dfac"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4d60660f32332d790f0c4206fe703c4ce7120fbb75de79d38afb58ddbd22bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d6ca86f522c45438f60cc399aa1ddba34cd78eaf74ffbe07a0367482c0d965"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws,k8s,vault", *std_go_args(ldflags:), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
    assert_match "module(k8s)", shell_output("#{bin}/risor -c k8s")
    assert_match "module(vault)", shell_output("#{bin}/risor -c vault")
  end
end
