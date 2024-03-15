class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d24f387a5e03a65a503632d1e7a874102e7f3331816e245d5fac9b4557d8c33b"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2c10d0c28949a4a5f869b29e079d4fbe86af54de0615038b01836a16196bc8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cca2bf625620d76c05fe938b6dee6848cb18a6c536239efc8a29009c2f75f7e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56ee5e1a662aadfb35cbca8204660e8313898eeb8fed1c8621bf2ad4f30629f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "96f35a357fddd3c33963c7c3ae9a4248eee92298f41e6cf4259d31ad28911518"
    sha256 cellar: :any_skip_relocation, ventura:        "249e2824dde87811bbbf401dfe5d5c0db4617dfad2c9f68a0c0eedd437c1f28a"
    sha256 cellar: :any_skip_relocation, monterey:       "20ec38eb23c52fc353ebf5731576477a1e388782d807477faaea48795374348f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9909bd6f2a3d59f494736e7d7ef6ffff689e90320151f231f2a395a876dd48c5"
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
