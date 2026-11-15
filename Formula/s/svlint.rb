class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://static.crates.io/crates/svlint/svlint-0.9.5.crate"
  sha256 "211e5b1c7318d29882248f3073b65d2d478693903a0ed8764231269d465812e3"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96d82c4e20a82bd080beea579bf022a7b3fa90d81f8bd7aa854f9233353d6f31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "594c7da5ccc947555a915789ce5ec36c7e0a233f76b9c6220368bd33b5c99aad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da54138563d1a7adcac56310d131b4f35f1205d5ff4ee0b6a2ea4a189f00c14b"
    sha256 cellar: :any,                 arm64_linux:       "68b2c16e2b9da6a4ce25878a04118e78c769fe87c9da8878db5925cd4f9290d1"
    sha256 cellar: :any,                 x86_64_linux:      "fa3108fe30d3a43652eece8658995b669a5b9d1924e1c3e39e5f0689588ad8d3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    # installation produces two binaries, `mdgen` and `svlint`, however, `mdgen` is for dev pipeline
    # see https://github.com/dalance/svlint/blob/729159751f330c4c3f7adaa25b826f809f0e5f44/README.md?plain=1#L26
    rm bin/"mdgen"

    generate_completions_from_executable(bin/"svlint", "--shell-completion")
  end

  test do
    (testpath/"test.sv").write <<~SYSTEMVERILOG
      module M;
      endmodule
    SYSTEMVERILOG

    assert_match(/hint\s+:\s+Begin `module` name with lowerCamelCase./, shell_output("#{bin}/svlint test.sv", 1))
  end
end
