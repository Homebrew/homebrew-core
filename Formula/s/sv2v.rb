class Sv2v < Formula
  desc "SystemVerilog to Verilog conversion"
  homepage "https://github.com/zachjs/sv2v"
  url "https://github.com/zachjs/sv2v/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "4ce7df8c6fa3857da6a2b69343c29e7c627a4283090f2b07221aa9ef956a88c8"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "97819574809287e39bcce5361e3354aa3a86c6b2885e1292b653d6b9ae89c86f"
    sha256 cellar: :any, arm64_sequoia: "81804764fa5072d33991cc95ceab0fa212a9929846734a8b5d009e95e6b097d8"
    sha256 cellar: :any, arm64_sonoma:  "469c8dbd540077f91cb887488cb839a1cfc03a638ceda790e10c35a35f926c15"
    sha256 cellar: :any, sonoma:        "6846634f25ccc35b2a6c873b964becb5bfc08c2d6cad91b13e1de96bc9b94326"
    sha256 cellar: :any, arm64_linux:   "8e2f5b5afd187c1afa9d6906b15259ef2236cb146bfe53bfe8083fc94e571ea5"
    sha256 cellar: :any, x86_64_linux:  "91976ff2075b7e212e2decbcaa8a330affebd310e382d0d7d663e721fbcda888"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sv2v --numeric-version")

    (testpath/"test.sv").write <<~VERILOG
      module test;
        initial begin
          $display("Hello, world!");
          $finish;
        end
      endmodule
    VERILOG

    system bin/"sv2v", "test.sv", "--write", "adjacent"
    assert_path_exists testpath/"test.v"
  end
end
