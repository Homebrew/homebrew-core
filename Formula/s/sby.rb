class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://github.com/YosysHQ/sby/archive/refs/tags/v0.53.tar.gz"
  sha256 "b62ad03264a73e02e5ffb3b73bfa3b420f47a00d6f82f203c15e2f19f8a60b13"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d3c4339e64fa6e25c1918d86817ac60e9dc2be7a5e0406b7f08567551672dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3c4339e64fa6e25c1918d86817ac60e9dc2be7a5e0406b7f08567551672dba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d3c4339e64fa6e25c1918d86817ac60e9dc2be7a5e0406b7f08567551672dba"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d3c4339e64fa6e25c1918d86817ac60e9dc2be7a5e0406b7f08567551672dba"
    sha256 cellar: :any_skip_relocation, ventura:       "5d3c4339e64fa6e25c1918d86817ac60e9dc2be7a5e0406b7f08567551672dba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3795e2284954d8980acb800d5ee3831a17fa93893a0ce4ba985fa77323d29f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3795e2284954d8980acb800d5ee3831a17fa93893a0ce4ba985fa77323d29f2b"
  end

  depends_on "yices2" => :test
  depends_on "python@3.13"
  depends_on "yosys"

  def install
    system "python3.13", "-m", "pip", "install", *std_pip_args(build_isolation: true), "click"
    system "make", "install", "PREFIX=#{prefix}"
    rewrite_shebang detected_python_shebang, bin/"sby"
  end

  test do
    (testpath/"cover.sby").write <<~EOF
      [options]
      mode cover

      [engines]
      smtbmc

      [script]
      read -formal cover.sv
      prep -top top

      [files]
      cover.sv
    EOF
    (testpath/"cover.sv").write <<~EOF
      module top (
        input clk,
        input [7:0] din
      );

      reg [31:0] state = 0;

      always @(posedge clk) begin
        state <= ((state << 5) + state) ^ din;
      end

      `ifdef FORMAL
        always @(posedge clk) begin
          cover (state == 'd 12345678);
          cover (state == 'h 12345678);
        end
      `endif
      endmodule
    EOF
    assert_match "DONE (PASS, rc=0)", shell_output("#{bin}/sby -f #{testpath}/cover.sby")
  end
end
