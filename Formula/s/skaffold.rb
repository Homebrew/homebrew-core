class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.20.0",
      revision: "78c964692057dd0d2a9a0608d504af868be521cc"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab67d884ceb28ee42dbc3fb4d1943c0fda672600c5ed61f5a2964fce599e4c42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "092a4a523d6954e9a7a1fb27a806b1e882206caa001f571b2f4b99525db4b71d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3216484a4b381f9ea8c8135ef8172935cf47480f437d56a1dde2eb45c0f515e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d5c9d66c8b8d6ec06627a5dbc4285035e28dc7fbea03545c076a98c876c149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b5df2575f04cff8fb13deae613da89345734b9e8a90e2e239e296eabd956ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674549f14c4baa65ed446573ccb8ed3272a8de8b1070177056c9a5ca243baf6b"
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
