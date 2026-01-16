class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.17.1",
      revision: "ec7f882772f87f940581c5d976924937b1561c26"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5de7df1b398cb7ca950d4a877e19c58e41f9a8d77a2ab015ceb663bd5dd3d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a7301e89bed06629a4e2b18e42a68ba884f49b30f13436d60abcd63d1247a88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c90696b051ca53589a05a234e8f918c39e177e9d99fb8f1545050354e3859a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4434a47f2087f0cad17be330fb084fe5c8174860bd09f765d5265189e2143ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5faeac21a184f269a5e00edd14494165d7bb9d9d7fdaa3175f49d037d9feab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aea929edb5f81847da4949eb41ae9481f80fc6e9845b66ca683f14138a00071"
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
