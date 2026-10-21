class Sby < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Front-end for Yosys-based formal verification flows"
  homepage "https://symbiyosys.readthedocs.io/en/latest/"
  url "https://github.com/YosysHQ/sby/archive/refs/tags/v0.70.tar.gz"
  sha256 "f2a3614f4ca56180d5e650d48a510fc8c1359b4f81a971634a479feb171f363a"
  license "ISC"
  head "https://github.com/YosysHQ/sby.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9db6f150976dc7fabb4e856f21eadf3034253bcd6c12c6d5d19254ef8e436907"
  end

  depends_on "yices2" => :test
  depends_on "python@3.15"
  depends_on "yosys"

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install "click"

    system "make", "install", "PREFIX=#{prefix}"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), bin/"sby"

    # Build an `:all` bottle
    return unless OS.mac?

    inreplace bin/"sby",
              "release_version = 'SBY '",
              "release_version = 'SBY v#{version}'"
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
