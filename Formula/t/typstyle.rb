class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.12.14.tar.gz"
  sha256 "053ae2b6349fe244f44dc816f7d91036c152eeb14bfc2c6bfeeca33cc5ac0c34"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759fba8d651af21577a615edb982b79e6d0f7fa23ca8f7cf277900168916bb76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "279c9d125533cc71206936b43984f94e17c11701d05c13ca53c5e71b9285b917"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86199b50c9190696ae34d53dae8c40f63d5a3d76ab4b03b47c61e79f3623a59e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f480fcfc34c4085dcb992e2b44a522199fbc517d0b6183aab90bde01c4249eac"
    sha256 cellar: :any_skip_relocation, ventura:       "b6b50d19095e5bd7aaafd78b2653c3c4563ae9afce8c0e1c903e6b86890a798a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92eaf6c364cb0a38df44abb3316dd07cb83b69a53045b7b815f66ce15b0d8a60"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
