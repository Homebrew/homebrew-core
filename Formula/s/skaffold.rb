class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.17.2",
      revision: "cb2a7c0b59da4b0a82df739d5d1486beae04b340"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eae557b92200f914790c5de531dbf77c2596577bb46cf533862a800ef12716c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554414d0553b014611141077db4fcfe76eb228a7ca1f9f40d2827ccdce165237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491d0a5e3eca344265763c008b9fd3f02f12462f66dcd0f1821cf4013c8dd9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "09067c0304fdc19d480a674f82f582554e01906f486208d5610ce05486a24b70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "763ae5ea19b97cdd3985c0239ee2cd5838aa8f5c01102a61099b5fcb0ae326b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6fd1ebb8607756450b7cd64bd309f811dadc0a710543815d80e11bc034a54b"
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
