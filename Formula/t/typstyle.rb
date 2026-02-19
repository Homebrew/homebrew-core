class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "c20a07b9535dc34c0099f744f435ebfb53668b92f05e59b115fd264ecb9f7187"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "082b4d350153ed64671a3dd28859555a574f7ff7b7e78659fe8302ec1c3bdf23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64ec1103ec0ebfaa9e2fc14db25cfb691e0da776da81e77356c77cb86aa5b2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c295a52306aa09bcf2cbd294cfdfc7d36c636b039a65b1ca9ddd5b93d5930d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c914e37ff44cac9601989fecd91575233b1d1b9ffbeda73bd139c2bece66f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12bdfb71ee6032207cb594f56cdb74ee8d0c189f3fa8075b1730f4a68110b7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e325b9666cecd8c1cf1d0bd926303c3a01c65a8fa2a6f24b781732c3009f6c2"
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
