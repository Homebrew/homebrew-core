class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.23.0",
      revision: "f9a9ed85e6c6830e0b54e3ce773703a031d14a8a"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f892d27339bb0aec44f6db110ed63afdb25bf07356c3edd218f0f3c2c452a7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e0050adf1ef07d5401a22c7a171f7198b164f6be83d9957aca8cae5278feb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60174359fd2d53beb3a01f9c10f2bf0b5500b835ce2c805b50e662009ecd525"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b5cb3149b7aff9ff2266e84adf548ebc56b09b49a4b38767d6364427782801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4da370e376e1fbf405bbcc52ecb03b3f3792203dabd02a28b3bb93e14cba7a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d598804d9abfd8b0d59ca537a9b9eeb83f29cc5d3fff8c1736833c3a28147cd"
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
