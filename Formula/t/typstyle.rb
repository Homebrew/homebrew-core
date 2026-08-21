class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "0f1b86584a0eb93b0cef374ddcc62508c46ee76cd8b5ede31414260d29a38f12"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d4814bc088ce3bfa9082ac35317abac0185d12e2860c1bc8fba4602efe74dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "073e5d7c82fefa4af929b9a6dc5cbf783b50ce6b02d899e520f61c088bdd3827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "061559d040369bd47ca21334652e2018f9e94c6cdab35affa6a3177e2423f0c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "45afd09ffe3a4feca5afb2ceaebda6478cfab315ecd312c45716cfe72210d87b"
    sha256 cellar: :any,                 arm64_linux:   "b219d37ebaa2197bae9ca416e9d1b1c0515913c13aaeb8cf2c6e68d78f2b1956"
    sha256 cellar: :any,                 x86_64_linux:  "cd469bc2f94e0593f04a2b7c8595d701e4716b9ddc1e6a3e52c1b417bc4677d9"
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
