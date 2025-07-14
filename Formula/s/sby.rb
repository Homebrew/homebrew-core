class Sby < Formula
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://github.com/YosysHQ/sby/archive/refs/tags/v0.55.tar.gz"
  sha256 "c1836692a4a0485fe91dea66119dc12c139ac78d5dcc4135433ce92cb3d1cabf"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b06211611640354025dc6bd7daab0955461ad94b41376103cd8eb353f574f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b06211611640354025dc6bd7daab0955461ad94b41376103cd8eb353f574f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b06211611640354025dc6bd7daab0955461ad94b41376103cd8eb353f574f86"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b06211611640354025dc6bd7daab0955461ad94b41376103cd8eb353f574f86"
    sha256 cellar: :any_skip_relocation, ventura:       "1b06211611640354025dc6bd7daab0955461ad94b41376103cd8eb353f574f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51e827ee20da920179dff6dc74b41fcc65adfce3e869470f1cf50bcdc42f259b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e827ee20da920179dff6dc74b41fcc65adfce3e869470f1cf50bcdc42f259b"
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
