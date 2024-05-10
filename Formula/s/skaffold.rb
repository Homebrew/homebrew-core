class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.11.1",
      revision: "5431c6bcbcca066347c0de2dfafca9ff143cd88b"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cd7b1d1007e1882a5f7f5c2378a3c3b9f5e558fda827a7e9d2d502a09d3fed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535104b3b530422207d52ba6af7d5ac7df81e5e4726a6bb379cd98c4a060346f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a572133de7ae5e7d1301bd92a64386156ab397513a26d848d0c9b384b30f4ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e65ee38168bc0ad1f2c972c6d7892e83a60f67fd82bdb72b31fd07a0dadd4dc"
    sha256 cellar: :any_skip_relocation, ventura:        "7ee95c1e903b590848565b7af751820966e2fd0b4c1d0bd99ae960081dddcd6f"
    sha256 cellar: :any_skip_relocation, monterey:       "2669a03dc743f35db9862b5cc9fbafff86dad69fe04a357cec64b7373da03735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f239b600007637d59c742f66f0e8289f27224bdd199fc99798e3885ab4a245f"
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
