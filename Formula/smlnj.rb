class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "https://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.84/config.tgz"
  sha256 "1810d3ca768222e120c7a3f2f93aafd652705371fc73929423c671dce3cef832"

  bottle do
    sha256 "d4441907f2dea02188487b3247e402d70b867a6bdd0e84da0cf5e8d7a0d44540" => :sierra
  end

  # Mojave doesn't support 32-bit builds, and thus smlnj fails to compile.
  # This will only be safe to remove when upstream support 64-bit builds.
  depends_on :maximum_macos => [:high_sierra, :build]

  resource "cm" do
    url "https://www.smlnj.org/dist/working/110.84/cm.tgz"
    sha256 "7055c60481a887f27a5135ac1f33233565b99a7c99c4aa73e023e28e629b0663"
  end

  resource "compiler" do
    url "https://www.smlnj.org/dist/working/110.84/compiler.tgz"
    sha256 "6d23aff2e75727bf6969b05a070128f187e06f60408aabf6a71e0475326fee87"
  end

  resource "runtime" do
    url "https://www.smlnj.org/dist/working/110.84/runtime.tgz"
    sha256 "5fcf4bbdeaddb247f69a333d2295f5f5c0be55b1f86ff4fbffb63f0021d84d6c"
  end

  resource "system" do
    url "https://www.smlnj.org/dist/working/110.84/system.tgz"
    sha256 "f46b1de790000a98f4aa9830325d39cb1e4867338d4db6b8a102084db1512218"
  end

  resource "bootstrap" do
    url "https://www.smlnj.org/dist/working/110.84/boot.x86-unix.tgz"
    sha256 "a29e3b0ca623da197e9c18ea64db4c2a08fe5e6add85c0d053c4ecfa653ace82"
  end

  resource "mlrisc" do
    url "https://www.smlnj.org/dist/working/110.84/MLRISC.tgz"
    sha256 "da3c5236018fa7608863c2fe1f3c57b60013df98b5a249fb3d4edc738cdfd072"
  end

  resource "lib" do
    url "https://www.smlnj.org/dist/working/110.84/smlnj-lib.tgz"
    sha256 "3356924655277416d8a491c1d601a0f567ab3d15cb17e243620e85cb28f0e9dd"
  end

  resource "ckit" do
    url "https://www.smlnj.org/dist/working/110.84/ckit.tgz"
    sha256 "7e2534e393d2372cad8ff9ddd306881db91bbbcc2b0e0538e76868c86c658c36"
  end

  resource "nlffi" do
    url "https://www.smlnj.org/dist/working/110.84/nlffi.tgz"
    sha256 "8b96a82a3d63b000b70a1b982aab9750ce9caa77f316f6a923969e86b0133f31"
  end

  resource "cml" do
    url "https://www.smlnj.org/dist/working/110.84/cml.tgz"
    sha256 "556110c746db863211ac8a97e1bf097b0e5d45dfea4b3e8194b6c389ac2b569a"
  end

  resource "exene" do
    url "https://www.smlnj.org/dist/working/110.84/eXene.tgz"
    sha256 "3fe1c6a1a334e7d7359fbcfd053066c88cb7705a90975b60fff946554aa0019c"
  end

  resource "ml-lpt" do
    url "https://www.smlnj.org/dist/working/110.84/ml-lpt.tgz"
    sha256 "2f60e1467a69fd4fb5501354244337926bc2a65225dde328f6aa3883b14fb3a5"
  end

  resource "ml-lex" do
    url "https://www.smlnj.org/dist/working/110.84/ml-lex.tgz"
    sha256 "cc7e045aa9667f1eed055db1defca0e830eed34c08f3dfdf37f698964fe04070"
  end

  resource "ml-yacc" do
    url "https://www.smlnj.org/dist/working/110.84/ml-yacc.tgz"
    sha256 "cfebaeb5f08810fcc93c49bf171834b7bf14b5f7e76d206e0afa35e18887bdb9"
  end

  resource "ml-burg" do
    url "https://www.smlnj.org/dist/working/110.84/ml-burg.tgz"
    sha256 "62ea37b13788078e3ea77d3b870da42788153c348009f827f2c0b05cfc07d918"
  end

  resource "pgraph" do
    url "https://www.smlnj.org/dist/working/110.84/pgraph.tgz"
    sha256 "aa2f14de13a540dbc370b45757156c0b03516a5b8f97b5759292841d7b7ac1cb"
  end

  resource "trace-debug-profile" do
    url "https://www.smlnj.org/dist/working/110.84/trace-debug-profile.tgz"
    sha256 "ecc54281b8654c75f8b9d4ebdf1ff67de71ef31297cf1b14115cd75645e46a5a"
  end

  resource "heap2asm" do
    url "https://www.smlnj.org/dist/working/110.84/heap2asm.tgz"
    sha256 "3d33c52b650536762d47534f07709e749cc821ce515aef2fb9a746db11433e95"
  end

  resource "c" do
    url "https://www.smlnj.org/dist/working/110.84/smlnj-c.tgz"
    sha256 "145a513becb4c98991af7eae81ae19b8fff336458f1f011eafdc283cb76deee9"
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
