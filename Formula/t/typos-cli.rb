class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.36.2.tar.gz"
  sha256 "23229bf78a136bce3c456019d71e25b57858275c8fd947426b8a5b32d639abe3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2405b4fe42beefa363cce59a74a3e3d619825517e83042bf6bf4d7a2c4ffcf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7444bc24f7c4a834e03820a12e11044c8bcb965857776390f6905d096f24b13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ecec523f433f5ab2734863124934ccce4caa8c2ccead487e5c8fbb889bdc98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9b1dda4f6088ae2429c5161391e51bba8b38bbd305869a20360836a3d32c7a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbcfedb12faa9baf66307677aba78865bd692c7076c9de0be23fb45ca9f6a4db"
    sha256 cellar: :any_skip_relocation, ventura:       "fde2c72bcc5d29bd52b7290b86ea6aed6cd149abe65cb3840cea5956c0be8193"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9827585c46363232bd7a4916ed93a693bcf87da27eef4ada89729152d94bfc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bb0fb2865aa3a41a75cdaa6e1fdd4dd174a14e05b49d098f070afb51387a5f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
