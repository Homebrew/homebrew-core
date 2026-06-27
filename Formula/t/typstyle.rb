class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "23dd94b7a3f0e5ca40827d3998cc9669457a6aad80a6e70bbb886111734dab3f"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af998275206796acd184b83c5e7ca76c336af1ecc1ad86b17c4dbf48dc1644fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ceb893bf69f2fcb8959c4996cbebb39340d9d31522776f7181e105d3537405f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f3cea5e98402dc698ab1756dac6d4eabe0cf367a3273d750fb1c9728419c3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3f6fbe24198895e100888402c59e9c8455ab1646bf7767d48132cd93dda33a8"
    sha256 cellar: :any,                 arm64_linux:   "2eaf719dd2d629d69dd37b1290da48f601dab61625e142fb462464b9ca8fe1c1"
    sha256 cellar: :any,                 x86_64_linux:  "66a4efe27585e7579fad170fa769f08578b5c97cc96b3add168154fd452511e5"
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
