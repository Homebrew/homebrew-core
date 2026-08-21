class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.24.0",
      revision: "b0d643a5b5944a7d3f82bd5c00d5eaa0902226bd"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc3bafc318fc280a56a4b99c3aacc51da207fbeaded8f67b470b72d54105419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939d458be252d35335f829f4d1819b7c27d3dd1bc94ef846a7b1073f1a5009ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af91c64508f9b5b797aa55b3178cdcc247af9aa21c39a0b817bcb961131806c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81542231d263ecb53388dd14f812dc36a4c2b53c445441527dfba6fa6e20a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed266796f0d88f664bb7896b494342411c4e8b9b64d3de58fed78e587d066df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8802a542fabe1ac52a70a33c75635aefa1b4f81e5ec35a87be67f705ddade7"
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
