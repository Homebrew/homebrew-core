class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.17.0",
      revision: "561ce51e1e2c4174b375e694a676585cea7c2b65"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d95de1ff8363297aab42dc69b069225639807840e0ef1bae5f6cedc822be0819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2e454fe2de09f41da35ffd4bc4fa876564eaf8972e6e31d14ddb8acdc1c312b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc1c259749887cad06d43e2fde73c2ecb74f06245aa8b0e30dccca27d5de8108"
    sha256 cellar: :any_skip_relocation, sonoma:        "016bebd2462adaf6cdb3a908d67688379cb48b49d73d4750c347afd79a3a89b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f21c7b05a6c2c1daee3d55234c85e6e54db5d5d636bddf439cb5cbff9c290d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8efe78bcd8bd6cbb04254d26cae21ae8760f1ea7674b82b83f06a529ee5901"
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
