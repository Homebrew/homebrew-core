class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "4b2821214bba5830f6010c017c647f28bb1a50f0c83f9305476bd6416d2fc28c"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d5db445fd87be22c3229477ebdd6899a0c938c7d0ad6493cd2a3160aeb4e30fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "902e0aa5af667a8168253190337eda7f35edf469418391556e2e2a3ccb654c00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52a2c1333fbeef4f932e0407443d0b8087956949552166fbad3a7cec131c2b8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fa2965570bde6073d421f93d671f25ae4cf49d9c715bc89495d3260af804159"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5c1d3ae4f3643277fa3b4d4fb49ba97e8a6ee685fdcd5ef458b5333e60f73bb"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce4466b940227ac5d4896e3e7bab320f2d90a26ca373125dffe6a0344d506c0"
    sha256 cellar: :any_skip_relocation, monterey:       "2b58d923661a7764f1b524a410b13400f035fc55f614521b62e79a43e637bb53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde90cf3b368d3538f2b805cec9a2e1029154671c753177f0c460ae24cb36cf3"
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
