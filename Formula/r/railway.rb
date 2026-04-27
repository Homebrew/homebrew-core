class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.43.0.tar.gz"
  sha256 "e7eeb56710d446ff8fd15093d801cd633c4f73b9749f64853164971016ff0b5f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b908ecb8ea1f32f169d4de9d7d600702a4d5912b80d12035a5e1ea807de61252"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f35e126657a5669a1e957009f2fbacbc8058aa79d966d65ceac9a16c0ea13c65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f656243ca8781974163a8656563c760b3babf75a929a9b3777bd0c9b8259197"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e693771880b11127853e43396a44f200f4e3731891ca337fe7c1a08a822df3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe6cc535da8d132f6afda4f18dd6957c2edd664b4cdf2b2208a870a8066f607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1eacc987350791ef93514030693733b7a34f8c48d6d7364528c5c644524b89f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
