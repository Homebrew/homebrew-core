class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://github.com/YosysHQ/sby/archive/refs/tags/v0.52.tar.gz"
  sha256 "8c14bcd6130a8db94764abc650046bf9986a4a5bbea662a03481ba546b6df5e0"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcf4c89082b4654f751f1608f89fbca25bf4d9d1bdc1e0d313ee54153af7cc90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcf4c89082b4654f751f1608f89fbca25bf4d9d1bdc1e0d313ee54153af7cc90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcf4c89082b4654f751f1608f89fbca25bf4d9d1bdc1e0d313ee54153af7cc90"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcf4c89082b4654f751f1608f89fbca25bf4d9d1bdc1e0d313ee54153af7cc90"
    sha256 cellar: :any_skip_relocation, ventura:       "dcf4c89082b4654f751f1608f89fbca25bf4d9d1bdc1e0d313ee54153af7cc90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73036051df4ee51a3f2ac8330f568f4ad070fca40aaff3ec912c5ecd44f77ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73036051df4ee51a3f2ac8330f568f4ad070fca40aaff3ec912c5ecd44f77ad6"
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
