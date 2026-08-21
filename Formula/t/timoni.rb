class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/releases/download/v0.32.0/timoni_0.32.0_source_code.tar.gz"
  sha256 "356434fdba6077f13e40aad300d4b3e56a11eb410d1f447da9f921523df0b09f"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf44a8160394c945ee60d516531d88821d0fda82e16defb70b12ebd83adf6532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a0fb18f72362ecefeaa49eeabbe58b43f0ac982cdd1a245e749373575752c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad601d30922634743f6e12fa031d803e731d1f26bef3e4be487122b856e727c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b135ab29bc088416050db5e837843f2bd777c657f1872a3ff120e05cdc3825b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef19aab3735362842e64156bb72cca7a35eefed8f014b3eb0a63884d12f2567c"
    sha256 cellar: :any,                 x86_64_linux:  "e7b1a32ad4480d67e9c8a11011aa39fd3f59d1044c59a70644d8f6a833bbaa2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
