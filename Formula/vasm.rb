class Vasm < Formula
  desc "Portable and retargetable assembler"
  homepage "http://sun.hasenbraten.de/vasm/"
  url "http://server.owl.de/~frank/tags/vasm1_7e.tar.gz"
  version "1.7e"
  sha256 "2878c9c62bd7b33379111a66649f6de7f9267568946c097ffb7c08f0acd0df92"

  option "with-6502", "Enable 6502 CPU target (binary vasm6502_SYNTAX)"
  option "with-6800", "Enable Motorola 6800 CPU target (binary vasm6800_SYNTAX)"
  option "with-arm", "Enable ARM CPU target (binary vasmarm_SYNTAX)"
  option "with-c16x", "Enable c16x/st10 microcontroller target (binary vasmc16x_SYNTAX)"
  option "with-jagrisc", "Enable Atari Jaguar GPU/DSP RISC target (binary vasmjagrisc_SYNTAX)"
  option "with-m68k", "Enable Motorola 68K CPU target (binary vasmm68k_SYNTAX) (default)"
  option "with-ppc", "Enable PowerPC CPU target (binary vasmppc_SYNTAX)"
  option "with-tr3200", "Enable Trillek TR3200 CPU target (binary vasmtr3200_SYNTAX)"
  option "with-vidcore", "Enable VideoCore IV CPU target (binary vasmvidcore_SYNTAX)"
  option "with-x86", "Enable Intel x86 CPU target (binary vasmx86_SYNTAX)"
  option "with-z80", "Enable Zilog Z80 CPU target (binary vasmz80_SYNTAX)"

  option "with-std", "Enable standard syntax (binary vasmCPU_std) (default)"
  option "with-madmac", "Enable MadMac (Atari) syntax (binary vasmCPU_madmac)"
  option "with-mot", "Enable Motorola syntax (binary vasmCPU_mot)"
  option "with-oldstyle", "Enable oldstyle (8-bit) syntax (binary vasmCPU_oldstyle)"

  # These defaults come from Frank Wille, vasm upstream.
  def cpu_syntax
    { "6502"    => ["oldstyle"],
      "6800"    => ["oldstyle"],
      "arm"     => ["std"],
      "c16x"    => ["std"],
      "jagrisc" => ["madmac"],
      "m68k"    => ["mot"],
      "ppc"     => ["std"],
      "tr3200"  => ["std"],
      "vidcore" => ["std"],
      "x86"     => ["std"],
      "z80"     => ["oldstyle"] }
  end

  def cpu_options
    opts = %w[6502 6800 arm c16x jagrisc m68k ppc tr3200 vidcore x86 z80].select { |c| build.with? c }
    opts.empty? ? ["m68k"] : opts
  end

  def syntax_options
    opts = %w[std madmac mot oldstyle].select { |s| build.with? s }
    opts.empty? ? cpu_options.flat_map { |cpu| cpu_syntax[cpu] } : opts
  end

  def install
    cpu_options.each do |cpu|
      syntax_options.each do |syntax|
        prog = "vasm#{cpu}_#{syntax}"
        system "make", prog, "CPU=#{cpu}", "SYNTAX=#{syntax}"
        bin.install prog
      end
    end

    system "make", "vobjdump"
    bin.install "vobjdump"
  end

  def caveats
    opts = %w[6502 6800 arm c16x jagrisc m68k ppc tr3200 vidcore x86 z80].select { |c| build.with? c }
    "No target CPU was specified with --with-<cpu>, so #{cpu_options} has been chosen by default." if opts.empty?
  end

  test do
    (testpath/"std.asm").write 'foo: .ascii "bar"'
    (testpath/"madmac.asm").write 'foo: dc.b "bar"'
    (testpath/"mot.asm").write 'foo: dc.b "bar"'
    (testpath/"oldstyle.asm").write 'foo: ascii "bar"'

    cpu_options.each do |cpu|
      syntax_options.each do |syntax|
        prog = "vasm#{cpu}_#{syntax}"
        system bin/prog, "-o", "vasm.out", "#{syntax}.asm"
        system "grep", "62 61 72", "vasm.out"
        system bin/prog, "-Fvobj", "-o", "vasm.obj", "#{syntax}.asm"
      end
    end
    system bin/"vobjdump", "vasm.obj"
  end
end
