class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.12.tar.gz"
  sha256 "bce3749b67a5cdf6cdb7a91168b73c91a56bd129a7bf66c747835d5e572078e7"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da8c697ab00df754547d88cb1cbb02e6610e1e6091d47d52cdea8ac5a9a0aa7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a87968a0d5b4bf51010f300dfeb6090a578595ea39b0a3cb0dd5b5a69e465f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e6ef452a873fdb55a1009d77fbebafe1bfe6776e0da911ac62c7d69edcd9e11"
    sha256 cellar: :any,                 arm64_linux:       "b692cc7fc521d72ce389052d619438e6cdea9b43a768ddb6de5cbb1f1d490dd6"
    sha256 cellar: :any,                 x86_64_linux:      "b75ab07399cf346af9ab689b24cd968fe40b1a495d170769a371c3ccb6dfdcb2"
  end

  depends_on "rust" => :build

  # `tinymist` uses `cargo_metadata` in build script, which fetches `crates.io` data
  allow_network_access! :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
    generate_completions_from_executable(bin/"tinymist", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"tinymist", "probe"

    (testpath/"test.typ").write("= Hello from tinymist\n")
    system bin/"tinymist", "compile", "test.typ", "test.pdf"

    assert_path_exists testpath/"test.pdf"
    assert_equal "%PDF-", (testpath/"test.pdf").binread(5)
  end
end
