class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.1.0",
      revision: "c037d6f51276e178a2c05c1c59665956ff34aa4c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7219ed397048efad7c51ddfbeed43b94a2f0cb34b6c4280cfba5fd87740aa92b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2be3a149316bdb205cf52cacd1184b21bc094d47de2ba09466f285369e26fba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c07939ed16e40ce7aaecaf35cc40de5d5f1a5f965c07aaf83cf8703e187d1e2"
    sha256 cellar: :any_skip_relocation, ventura:        "d913ca23899d452875f7a2d70bc67188911898cf18a2acdce25d2165a21bb423"
    sha256 cellar: :any_skip_relocation, monterey:       "b6fc296c4de9006c261d5720f53c9c9ca040c0e509d19d5afcf37b1710290788"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f824f399aeefba17bd9d5a60645b20dfa9507b4f0153262557da1ad98da54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9d01a4758ef95cdf54ec96ee018bc3c343c8fcb102a4e7ea584cb3f55e651f"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
