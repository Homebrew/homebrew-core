class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.18.3",
      revision: "122e7914522ebce23ead9705c55b93a2b6a781c8"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d3d4072d5b30371ed9c74b5c37fce996ddc9cb3aa71062fc46ae0af65948ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e347688999113b3a633517274a0e6220a9d4f84f3b9a0bae3ab3843d7dd1c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59790ad9cea41feb66a3601ea7efbaee50646e141a3a2d37b12e2559ecf52677"
    sha256 cellar: :any_skip_relocation, sonoma:        "777050827ee404460fcf9744223a2cd57e0d68f56123a7806f5cfea16ea13b78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce3707cb72c09047b1ecfe82142079183f5f04702602aeab3526893030a8db6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df82a337a402a36b6d085a80456256df7732472bc2da750cda593705121d09ce"
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
