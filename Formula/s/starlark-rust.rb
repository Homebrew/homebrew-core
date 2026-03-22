class StarlarkRust < Formula
  desc "Rust implementation of the Starlark language"
  homepage "https://github.com/facebook/starlark-rust"
  url "https://github.com/facebook/starlark-rust/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c27d974dd242f133184a5fc53a145374f193464e163fa6fbd4cade566e3cfab6"
  license "Apache-2.0"
  head "https://github.com/facebook/starlark-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25035b0a2ca0a499dc940cd416dba460eb7b3d22871b17a67553c9d67fb0817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c7d216f76e62d7afb443c1149081a879e2e640809951608bb306f6b7e3c75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be2257f4dc600df454dacfbcea964d0b03fd3b90cc8d9a92dba570f0cbbffb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18151d79509ac6e9c1d7741945ebae060bd7ab048cc28eaf2f3b31de2259e430"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf96fdd0735366f05e37edc5abbc585196aeebb1b697c37a9c3518981564dfb"
    sha256 cellar: :any_skip_relocation, ventura:       "ccf2d7a29bbc2a0566a42ada228674c763355bf3cfa7da07641bdbeab8090f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6c2c092d1cda4e6535a19d73f00d925a0ad2aaf07741ec66fd85b099617e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da66eb0fccc9b12bd61613f0027e869baeeb98d771ab5537ec61c30a488aa72e"
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
