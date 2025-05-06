class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "acdee42ef6794050cd08eb658b450712be7b678295267a1d9a990eb0ccd9eb79"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2541e5eb43f0d5bdb51d96b1aca9bd3d041c3c72b7484adf20d92aa93cfee511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0fb7922a182e1d7ba638e46fd78ed11be0a8b4a7a6f71793a4621fd7ef7e065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49a28889261bb7e6fa865956ce6e320f8f8bf26ce9c8f2e02857f83eca8625aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "513cf30bd2d18a8a1c8cd961adc1d516ae42317b478c1b39969401a0dbce7cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "ce620f68649c47d93df05fe712bec7cd55cef8c69b98bf93e64b3f07b731093a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f56b755f6976138ec62da9c8045444859f8b4c644b403b8663314a3fd945f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "050909fc7a654bfaa38872db38d8930513fb8820d92a4e7d0860ba6d7bf53936"
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
