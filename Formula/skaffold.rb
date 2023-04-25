class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.3.1",
      revision: "701c45c772e185c0ee937eb027fe36e8d417c4a7"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30ec1940411a1dde538ffbd3dd40429b74970e162628fd792cefd2558c5978ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b1a5bcf54b593a590841da94cdf39a5402823f753172d1c2110c9bc8b59d3f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45c9d7f8142efbe9ecc6b696d509cfe043b405840fba689325801f15698b84a6"
    sha256 cellar: :any_skip_relocation, ventura:        "3d8d6a9d2bad3327a5b78bfedf6f569b2f8de030cb229b5a1b8dd14183857e4e"
    sha256 cellar: :any_skip_relocation, monterey:       "33e82b1e88a483e236018c8dcbac2a5e2b0ca488f3c8fac91a0d8652352724bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "68e2673125c13229c8468fdde2b9ceb44db903c548a6930698b68025cfc32c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c74b888f882be1d4b82f5c571ffde749ad1928455ac144a20c96623092949137"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
