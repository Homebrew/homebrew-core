class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.16.2.tar.gz"
  sha256 "beb0f292d8375cddb82d25f11f5c203073c1d3e2437807450ddcad31758be8aa"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c09f844cb7507641705d8ccdedb6fa97c0b587d710e3fad087fce312291279a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f16a90ce4df5c0254698fb48321360a3ee192bf09e22f2a49817fb82da786eb"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b9c27cb053e7b42bd5b341ac0dd5404a21f68009edaa9f805fb54143c9a23d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6679351996bf79acd69e26932809a002258aaf9330f354d2d01e95ddcdb7c570"
    sha256 cellar: :any_skip_relocation, catalina:       "f9e293b8b97d9197fddb936fb5967a5fe58234f0f302e0849d2d77ceb1d931fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8f2d4a4093b1c40634d9677809c8c2b5e6ea8949cd4683937d3e882fc5de52"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    (bash_completion/"yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read(bin/"yq", "shell-completion", "fish")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
