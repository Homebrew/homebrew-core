class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.25.0",
      revision: "d915e113210eb7590ccbc8363aeab38053172ab3"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b199a8893f665e1bc4df417594444528fa05ad79d414454c804848cc6aa04de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13e7ae33fc8442e1f41f6fd52ad97c22822d261ef08253b01fb39a93b576f77e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0854ef9b2d8dabb9f89d79726272424b108f31dd2f37f96f892acd0f62548a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d07f6b3ce594ba4aa5616a7464726237dbcffc85dd0efa327a59351b127cbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7b82fcf61d5aa3666aba78f521516116c767cd7133cdf1fad48443275dc7f37e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
