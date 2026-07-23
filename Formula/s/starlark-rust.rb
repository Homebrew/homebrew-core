class StarlarkRust < Formula
  desc "Rust implementation of the Starlark language"
  homepage "https://github.com/facebook/starlark-rust"
  url "https://github.com/facebook/starlark-rust/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3a0030b4fe1becf62698a6aed0dbbbd68397e7406fa0eca078849622b93d56e4"
  license "Apache-2.0"
  head "https://github.com/facebook/starlark-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "825e07ddc6c08fa50a71d051b66a59fd8cd38e4ca53b38acc968dc11bfe0bdfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae98c072625fe0df9231a0543b6028af938b9a6f1f395969517f9d029a62f1c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4024a552892c5ab4011f796df1c34e14082f19f339ca0c831111d7f8d1de92d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eef8634a3026531eb4377653efb039870a4441d4c4ab744c051d2e7f82a9167b"
    sha256 cellar: :any,                 arm64_linux:   "d269181238dc68785e98d63bf661e3a556ac39e68f280f3129dfebd87e82a3a9"
    sha256 cellar: :any,                 x86_64_linux:  "11eb8954790dd2831b2eac2c8b48b7133319f33dd09abf70010c8a601b7a4069"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "starlark_bin")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/starlark --version")

    (testpath/"test.bzl").write <<~BAZEL
      def hello_world():
          print("Hello, world!")
      hello_world()
    BAZEL

    output = shell_output("#{bin}/starlark --check test.bzl")
    assert_equal "1 files, 0 errors, 0 warnings, 0 advices, 0 disabled", output.chomp
  end
end
