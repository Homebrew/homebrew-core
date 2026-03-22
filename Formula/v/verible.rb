class Verible < Formula
  desc "SystemVerilog parser, linter, formatter and language server"
  homepage "https://chipsalliance.github.io/verible/"
  url "https://github.com/chipsalliance/verible/releases/download/v0.0-4051-g9fdb4057/verible-v0.0-4051-g9fdb4057.tar.gz"
  version "0.0-4051-g9fdb4057"
  sha256 "cb51944e4f1ba52bc11983bc169aa10b9dbd6622b39640bec8e374eed4f21976"
  license "Apache-2.0"

  depends_on "bazel@7" => :build

  def install
    rm ".bazelversion"

    ENV.remove "PATH", "#{Superenv.shims_path}:"
    env_path = ENV["PATH"]

    args = %W[
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --compilation_mode=opt
      --cxxopt=-Wno-range-loop-analysis
    ]

    if OS.mac?
      macos_version = MacOS.version
      args += %W[
        --macos_minimum_os=#{macos_version}
        --host_macos_minimum_os=#{macos_version}
      ]
    end

    system "bazel", "build", *args, ":install-binaries"

    bin.install "bazel-bin/verible/common/tools/verible-patch-tool"

    verilog_tools = %w[
      diff/verible-verilog-diff
      formatter/verible-verilog-format
      kythe/verible-verilog-kythe-extractor
      kythe/verible-verilog-kythe-kzip-writer
      lint/verible-verilog-lint
      ls/verible-verilog-ls
      obfuscator/verible-verilog-obfuscate
      preprocessor/verible-verilog-preprocessor
      project/verible-verilog-project
      syntax/verible-verilog-syntax
    ]

    verilog_tools.each do |tool|
      bin.install "bazel-bin/verible/verilog/tools/#{tool}"
    end
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module test;
        initial begin
          $display("hello world");
        end
      endmodule
    EOS

    system bin/"verible-verilog-syntax", "test.sv"

    system bin/"verible-verilog-lint", "test.sv"

    formatted_output = shell_output("#{bin}/verible-verilog-format test.sv")
    assert_match "module test;", formatted_output
    assert_match '$display("hello world");', formatted_output
  end
end
