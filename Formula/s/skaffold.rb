class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.13.1",
      revision: "9bf608b553673654891eaa4d79ef84b21749ef0c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c014120d36e19127987b8e3d0d8470a370db295a0e44a62202198050f650333"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbfd39e623a53321686075487afa14f478dee28e1f7ea800c9e8016dd6b39d9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa5765e57e6ccc9f4bc184d4de30159527aa1592279330c9b620c6d2e81f46b"
    sha256 cellar: :any_skip_relocation, sonoma:         "77a7adfa0b70eec8a11d4ae92ff421a7729bb197fc313eff1d2e553dbddcf6c7"
    sha256 cellar: :any_skip_relocation, ventura:        "75ba5567196376d02336f717ae277e61ac5f8815d6aadba05aa29584ec6c4e44"
    sha256 cellar: :any_skip_relocation, monterey:       "ae96ea756f43245ea3584d7317151efe135c1b4d87fd8f3f062dc668be43b28c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714e6d8fddca66fb821180044d950a277f925aed640944790fc60e321f0b16a0"
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
