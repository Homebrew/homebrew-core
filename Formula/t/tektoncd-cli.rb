class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.32.0.tar.gz"
  sha256 "18e49e09b1fbc9fbfd91dbf2a26d22a4e55ea9afcc526924b79a9d6464c13443"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1977917a48c3ae437f7ec021155c6ba279c96148b10c3d1acd9bbe9263e448c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dbf0eacb86fac370ad29ffe093ddaeba56a16070b50ab797213fe8bc8c3d52c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "203807c49b1838e0500ecf52d6d6556187c7bc6fcb7137afda13034092157259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff3c234879251f3ca3c897afd3a422faef50c42ebedfe3da86d16b846ec8eec0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c1734eb04b29a77f4df9081b233925777ae29f87d9710998c4a04a4a4c11ca4"
    sha256 cellar: :any_skip_relocation, ventura:        "d841ab530683d553ffae0a9df7faff24959b09d05764bd38c5957ed9113cad41"
    sha256 cellar: :any_skip_relocation, monterey:       "c9563ffbdb03dbdbc81a110e24faeee42a7b8378993718ec90595b31ce9975a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "45017827bb0462a9176fe7a14f27ce58dfcbade59af8c9f040f6aaf079e92f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a097d8aa045645f3e4f5431290690d408c3f1df405b0895da1d424bac08ac8c2"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
