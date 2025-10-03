class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.13.17.tar.gz"
  sha256 "ecf01327e3543c076faa8aab3d350fdea01c96c11df1f528d2a0cce40d963bd7"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2d295d229642c4f6121f04e741170203c73cff10b9ff1a53f37fbf725605b41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2712c14da467fdafd38c2f1b562bad2e7d415203d3b5f7d1501aa9d109f50cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "688161dcee3ed87bd0c650e46fc0ae9409bcd5e0508344b8ea5e60372217d1e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f63a0ca6d0ac93de8b06ec7eb1d369d7226fd68140b37221feb54bdf5f84d512"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0d3e1780763a7cfc9a3f1c7efe747784aaf70dced318a678af44577a719515c"
    sha256 cellar: :any_skip_relocation, ventura:       "9878871a41d72598bb0396efdffd0bc11315abf7633d6b1a9ee81ac425652a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa61e3bf7f4b665d722e3768b15247014a25246a667842a0a12c1995568a879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a075f73c5ce9d7416611f05faac5c5244a02caca95ce9e5ef0aefc80a916b4"
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
