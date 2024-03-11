class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "559800bc2d1b763fa8ff33443b6b6afed748b5203bb6ac7e5d6e3ced08804ec7"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f85b15d1f46d123f3d768f4b2707b4c5c7d94aff891b8913ef20bfbf0037463a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70b483f5bafae80d86c4e615939175f544364d6332e13cc0e5e8640fed253872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45e1ac041c4dfbdec6fd733a62ce56bb98378a38d6a052058ac490d1b0688e8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "13a3e48c2d5c1c6c80828bfa75277b98a2a790eb4a1b6965ec7e1aec85317585"
    sha256 cellar: :any_skip_relocation, ventura:        "3f9b157c1c73631e054a421c3151141c816adbe97cba405952a05cc2d8d4f2c0"
    sha256 cellar: :any_skip_relocation, monterey:       "9ccd587bddcefb9ff8e73de9e8575eb7aa5e34ce4b0caa55a5d4b665b5c3e9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6161780d2926102082c5819c31846419618864c637a18d1b51f4816cc0bf605d"
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
