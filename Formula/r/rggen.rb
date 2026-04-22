class Rggen < Formula
  desc "Code generation tool for control and status registers"
  homepage "https://github.com/rggen/rggen"
  license "MIT"

  stable do
    url "https://github.com/rggen/rggen.git",
      tag:      "v0.36.1",
      revision: "927e6c18ffcf6e624221f97df5680f2e8a2d63bc"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        tag:      "v0.14.0",
        revision: "d54d92b4e17c1607947f1b6d108ebd94d80e2686"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        tag:      "v0.7.0",
        revision: "b4e65cbd81d35dda94dc58b4c67262ae9fded49a"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        tag:      "v0.13.0",
        revision: "d8872192d78381b416423d0e5c88315d4d6c0578"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37f1ceb0085f6a7f03093d7cf54e998f4df5e1b25ec0dae6365c5020bbab57b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f1ceb0085f6a7f03093d7cf54e998f4df5e1b25ec0dae6365c5020bbab57b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37f1ceb0085f6a7f03093d7cf54e998f4df5e1b25ec0dae6365c5020bbab57b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "caa811466dcfc98feb7fdd7fce8b8baa0bf3f12d24bc9f7b4df7e44971ccedfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35fdce56b3c59e689592a0a6b3c8803e211384d3c4b43cbb47a9c4fda4c6f02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff477fca88784c844ec9b3c25d36bb19c1044acd06ffb2af1e814e27650ea7fa"
  end

  head do
    url "https://github.com/rggen/rggen.git",
      branch: "master"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        branch: "master"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        branch: "master"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        branch: "master"
    end
  end

  # Requires Ruby >= 3.1
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    %w[rggen-verilog rggen-veryl rggen-vhdl].each do |plugin|
      resource(plugin).stage do
        system "gem", "build", "#{plugin}.gemspec"
        system "gem", "install", "#{plugin}-#{resource(plugin).version}.gem"
      end
    end

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    test_file = testpath/"test.toml"
    test_file.write <<~EOF
      [[register_blocks]]
      name      = 'test'
      byte_size = 1
      bus_width = 8
      [[register_blocks.registers]]
      name = 'test_register'
      [[register_blocks.registers.bit_fields]]
      name           = 'test_rw_field'
      bit_assignment = { width = 6 }
      type           = 'rw'
      initial_value  = 0
      [[register_blocks.registers.bit_fields]]
      name           = 'test_res_fieldres'
      bit_assignment = { width = 2 }
      type           = 'reserved'
    EOF

    command = "#{bin}/rggen --plugin rggen-vhdl --plugin rggen-verilog --plugin rggen-veryl --load-only #{test_file}"
    assert_empty shell_output(command).strip
  end
end
