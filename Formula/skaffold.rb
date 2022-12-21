class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.0.4",
      revision: "01dd5065e6c1f91b046edef95074e68050a9c28c"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "997afa6d45a785391ab71e77669d9bac5f0646da449c234056560878206856ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba417b5b93e1d82021c982842d511dae6ae1d1a286479ec1670b38b13d1e9a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4db87fdb5fe0b24c66e6f12fabb50a940743bb5d63451ad328f70aed04c0ace"
    sha256 cellar: :any_skip_relocation, ventura:        "f8eb08ad2e612433871a98d2fe4a75a25fafd029595d23d24db30e3eeaf8760e"
    sha256 cellar: :any_skip_relocation, monterey:       "cf7c3bb21b09749dcb24ab03b88b040320e08e918e512fbdf08a61e6abe20873"
    sha256 cellar: :any_skip_relocation, big_sur:        "f785da7da9a6557eb1a9da2718c08d0a4d0ab9d7354acf088b636aa99f3b0724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a9ede8c6a6e50ca7bdeaa21b743f494b71786bedc49a5be2315a6f88b7b9ad"
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
