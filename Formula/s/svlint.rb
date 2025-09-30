class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "989555c119fb24b93aaec3ebf4dc8a4469f8a61880f7482683316180a2062a54"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d40b78886e5598a3f1e7ab0bc66572e6e7d2c848ceeb7ddaad8d42737132c755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc512aca745d4aa144c5c1e747f83c2379c2ab9ff59003b814528e6bc17b3c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77af372524eac001d83bfd9a64d2289ae559ecf29cc3da6e9994a42080785ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6b32034e9b4c0acdf08b05b30ea05eb70d9591392c0fd2bbe8ccc2c32ebd368"
    sha256 cellar: :any_skip_relocation, sonoma:        "43270ec7ea8569238437f95a9bb548e483d8d95d49f71d16ebc3bd45756dbba8"
    sha256 cellar: :any_skip_relocation, ventura:       "8787afb02c4a3cef60eabb963e881cee53b4331cb42d1820c54cd771b4b4069d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c52133f3b10c69aec264a3a1372abef0bf7d9238b38faad08a476894805de8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab4834d5d9e90d2e26c7a46029013e12e0f6c59febf6a3a94c6541c15ac3762"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # installation produces two binaries, `mdgen` and `svlint`, however, `mdgen` is for dev pipeline
    # see https://github.com/dalance/svlint/blob/729159751f330c4c3f7adaa25b826f809f0e5f44/README.md?plain=1#L26
    rm bin/"mdgen"

    generate_completions_from_executable(bin/"svlint", "--shell-completion")
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module M;
      endmodule
    EOS

    assert_match(/hint\s+:\s+Begin `module` name with lowerCamelCase./, shell_output("#{bin}/svlint test.sv", 1))
  end
end
