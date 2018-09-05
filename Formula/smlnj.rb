class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "https://www.smlnj.org/"
  url "https://www.smlnj.org/dist/working/110.83/config.tgz"
  sha256 "997d74d1a3e7e6b22c3002bf69a6003173c856d59baba79e93073f9c7f3eacaa"

  bottle do
    sha256 "c679fbcd1ebefdb3d376a7696567e567bea7c6c8eba193694f34ba157c00e6f5" => :high_sierra
    sha256 "6a8ccb025d55f8a7b25c98579d8a740356a70b08eb91d85e2bcf8754b11dd473" => :sierra
    sha256 "5b9c47a182ba4aedb57897163c6e8fcbd89ebe23cbf9392f121c97f7d7e6678b" => :el_capitan
  end

  # Mojave doesn't support 32-bit builds, and thus smlnj fails to compile.
  # This will only be safe to remove when upstream support 64-bit builds.
  depends_on MaximumMacOSRequirement => :high_sierra

  resource "cm" do
    url "https://www.smlnj.org/dist/working/110.83/cm.tgz"
    sha256 "89ccb520252097d83b8bdd70acc6f8bfbb662880f71bd0e516518c390454b2ca"
  end

  resource "compiler" do
    url "https://www.smlnj.org/dist/working/110.83/compiler.tgz"
    sha256 "4887d767566a2dc5276315ae51c84ae4d2317523c0683f91c7df7e8a4300b463"
  end

  resource "runtime" do
    url "https://www.smlnj.org/dist/working/110.83/runtime.tgz"
    sha256 "0254a24e4438a4b19e4d97a44306d0aa3063dfc5ab2606c7efaa664778c47173"
  end

  resource "system" do
    url "https://www.smlnj.org/dist/working/110.83/system.tgz"
    sha256 "1d30c9e7ff386b7f09b98863c3778e2a008c9404a50d20f105f3d3dfb950f091"
  end

  resource "bootstrap" do
    url "https://www.smlnj.org/dist/working/110.83/boot.x86-unix.tgz"
    sha256 "5830522e5981ba9fb6d01201db53f26285e6a251bedaf9dd87db0b9edf540b09"
  end

  resource "mlrisc" do
    url "https://www.smlnj.org/dist/working/110.83/MLRISC.tgz"
    sha256 "1842f9c6db8aa3e685af5b3fa73ab1162b3ce4aefb28a9d1b46f070564152455"
  end

  resource "lib" do
    url "https://www.smlnj.org/dist/working/110.83/smlnj-lib.tgz"
    sha256 "eabb1eee5a4ca09bc5d244625c1a58ad51199df682c572a322b296921d3b2364"
  end

  resource "ckit" do
    url "https://www.smlnj.org/dist/working/110.83/ckit.tgz"
    sha256 "6ab5db28b154c925e538b6cde886d7e0eee0bff24a3e01b950a2bfbdc8866921"
  end

  resource "nlffi" do
    url "https://www.smlnj.org/dist/working/110.83/nlffi.tgz"
    sha256 "eabcb899e9d16720ce2f44dda074236691aa5dacac05af8741a288e0d2c2dd5b"
  end

  resource "cml" do
    url "https://www.smlnj.org/dist/working/110.83/cml.tgz"
    sha256 "28e9bff3598dfa0bc58b7aa4d9031509109fbb3b2bb17fc389f4f7c669d531d9"
  end

  resource "exene" do
    url "https://www.smlnj.org/dist/working/110.83/eXene.tgz"
    sha256 "569f39e2468c1fd699092272cfe5f56e5d6d7a010f17881061d242d443f0d508"
  end

  resource "ml-lpt" do
    url "https://www.smlnj.org/dist/working/110.83/ml-lpt.tgz"
    sha256 "ec9f407659fca997fb0714edafd4079e8d356463f9e6b7cdf787b6bf8b35fdec"
  end

  resource "ml-lex" do
    url "https://www.smlnj.org/dist/working/110.83/ml-lex.tgz"
    sha256 "beb1ef366db2034966eb9832bf6f8168513f58f18f34b38a6b7ab92f960b2e7e"
  end

  resource "ml-yacc" do
    url "https://www.smlnj.org/dist/working/110.83/ml-yacc.tgz"
    sha256 "2789f4f7b1e1b6ac0874d2232ea4d7aa44adccb655934227058b3153f9be2607"
  end

  resource "ml-burg" do
    url "https://www.smlnj.org/dist/working/110.83/ml-burg.tgz"
    sha256 "11e079d7ac5dde5e67457480053cd0e37dac343cb35fb0a7135df2bbb48426c5"
  end

  resource "pgraph" do
    url "https://www.smlnj.org/dist/working/110.83/pgraph.tgz"
    sha256 "a81a664aef82ad1f336cd9b320d1cd5351abb9bfd915f0179a62054508df6c0b"
  end

  resource "trace-debug-profile" do
    url "https://www.smlnj.org/dist/working/110.83/trace-debug-profile.tgz"
    sha256 "1cb5559445805017f16f56df348e7e5c75352e060a8a43ea600e4300cab59a14"
  end

  resource "heap2asm" do
    url "https://www.smlnj.org/dist/working/110.83/heap2asm.tgz"
    sha256 "bf8a2fee9b1b345418b5252b05f059133afd3849b949b0249a7e9635fca43813"
  end

  resource "c" do
    url "https://www.smlnj.org/dist/working/110.83/smlnj-c.tgz"
    sha256 "5974c86a9fda680247ad69b8afc8d3bd32831b8256ce64a231a5dcdefcb793fb"
  end

  def install
    ENV.deparallelize
    ENV.m32 # does not build 64-bit

    # Build in place
    root = prefix/"SMLNJ_HOME"
    root.mkpath
    cp_r buildpath, root/"config"

    # Rewrite targets list (default would be too minimalistic)
    rm root/"config/targets"
    (root/"config/targets").write targets

    # Download and extract all the sources for the base system
    %w[cm compiler runtime system].each do |name|
      resource(name).stage { cp_r pwd, root/"base" }
    end

    # Download the remaining packages that go directly into the root
    %w[
      bootstrap mlrisc lib ckit nlffi
      cml exene ml-lpt ml-lex ml-yacc ml-burg pgraph
      trace-debug-profile heap2asm c
    ].each do |name|
      resource(name).stage { cp_r pwd, root }
    end

    inreplace root/"base/runtime/objs/mk.x86-darwin", "/usr/bin/as", "as"

    # Orrrr, don't mess with our PATH. Superenv carefully sets that up.
    inreplace root/"base/runtime/config/gen-posix-names.sh" do |s|
      s.gsub! "PATH=/bin:/usr/bin", "# do not hardcode the path"
      s.gsub! "/usr/include", "#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?
    end

    # Make the configure program recognize macOS 10.13. Reported upstream:
    # https://smlnj-gforge.cs.uchicago.edu/tracker/index.php?func=detail&aid=187&group_id=33&atid=215
    inreplace root/"config/_arch-n-opsys", "16*) OPSYS=darwin", "1*) OPSYS=darwin"

    cd root do
      system "config/install.sh"
    end

    %w[
      sml heap2asm heap2exec ml-antlr
      ml-build ml-burg ml-lex ml-makedepend
      ml-nlffigen ml-ulex ml-yacc
    ].each { |e| bin.install_symlink root/"bin/#{e}" }
  end

  def targets
    <<~EOS
      request ml-ulex
      request ml-ulex-mllex-tool
      request ml-lex
      request ml-lex-lex-ext
      request ml-yacc
      request ml-yacc-grm-ext
      request ml-antlr
      request ml-lpt-lib
      request ml-burg
      request smlnj-lib
      request tdp-util
      request cml
      request cml-lib
      request mlrisc
      request ml-nlffigen
      request ml-nlffi-lib
      request mlrisc-tools
      request eXene
      request pgraph-util
      request ckit
      request heap2asm
    EOS
  end

  test do
    system bin/"ml-nlffigen"
    assert_predicate testpath/"NLFFI-Generated/nlffi-generated.cm", :exist?
  end
end
