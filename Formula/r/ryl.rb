class Ryl < Formula
  desc "Fast YAML linter and formatter written in Rust"
  homepage "https://ryl-docs.pages.dev"
  url "https://github.com/owenlamont/ryl/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "125a621004b0eef0963fbb4261a335de3f4afb82fb789297efbd0ff9de8249ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f8233381f09234b75beedfd85b9cb09d329018097e40ee2e1cb29b4c3a3f0ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a1ab35b3e455f2cdfbdb7e7117e1f96197fd92f68bd389c07bbf9204f1d8318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "270be8aa0f6abb476dc03521162dbbdbd4c28755210303f3499688ee259cf18a"
    sha256 cellar: :any,                 arm64_linux:       "b762cc34ec8fbebec550c9c3b998360cdba372cd84ae61d54178f2beb4699d1a"
    sha256 cellar: :any,                 x86_64_linux:      "0330c5227605e7b31987b13c7790ff2b2a3cc204ea99c8c9f763fd82ddbedb12"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ryl", "--generate-completions")
  end

  test do
    (testpath/"valid.yaml").write <<~YAML
      %YAML 1.2
      ---
      ...
    YAML
    system bin/"ryl", "check", "--enable", "ALL", "valid.yaml"
  end
end
