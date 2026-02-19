class Rggen < Formula
  desc "Code generation tool for control and status registers"
  homepage "https://github.com/rggen/rggen"
  license "MIT"

  stable do
    url "https://github.com/rggen/rggen.git",
      tag:      "v0.36.0",
      revision: "cf27c0abf99ab2fd421c1973885265af3e37046e"

    resource "rggen-verilog" do
      url "https://github.com/rggen/rggen-verilog.git",
        tag:      "v0.14.0",
        revision: "d54d92b4e17c1607947f1b6d108ebd94d80e2686"
    end

    resource "rggen-veryl" do
      url "https://github.com/rggen/rggen-veryl.git",
        tag:      "v0.6.0",
        revision: "d29d7ae019b9c6832780d519af38b99222956c8d"
    end

    resource "rggen-vhdl" do
      url "https://github.com/rggen/rggen-vhdl.git",
        tag:      "v0.13.0",
        revision: "d8872192d78381b416423d0e5c88315d4d6c0578"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33ddf9d1d2c3b59608d7a8e54b1ad23f80bc23a79afb65d2852a378d8fabc3f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ddf9d1d2c3b59608d7a8e54b1ad23f80bc23a79afb65d2852a378d8fabc3f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ddf9d1d2c3b59608d7a8e54b1ad23f80bc23a79afb65d2852a378d8fabc3f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d399b62b9439b97ee46cb99a82c774597d5adabc055d8e201742dfc3054bf1ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb995088f33883ce1d0263a1c28f7b7ecc725c017e05e1403b140ae8b5e26c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd45a736c5e4828626655161e7476fa4d807b605bb474d3989a75be34f8c316"
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
