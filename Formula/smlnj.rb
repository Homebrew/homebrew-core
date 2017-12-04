class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "https://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.81/config.tgz"
  sha256 "a993d2d967455ec48d7689348ee3a7dce7c80cf5e6ce40ee5e0b30bbba620f2f"

  bottle do
    rebuild 1
    sha256 "453e8cea76fe2330023a8db1cbfbc6429d046ece308dc087e05af4220ce211d2" => :high_sierra
    sha256 "5ebfe510656e7484c41620727a3523841939cfc10585ab5cce3dc7f7b846540b" => :sierra
    sha256 "e2e07693b2f775e68a71382a0d3b8a93e017be550f2348e2ca960a0eddffc943" => :el_capitan
  end

  resource "cm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/cm.tgz"
    sha256 "2b5448906967e55ceb8acab1e301a80d26c23cb717e1f17a73eaa6340fb4dbf3"
  end

  resource "compiler" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/compiler.tgz"
    sha256 "44bbff8bcaedd00d7c87f51c9d28e1d03ff791a7e15bd11d5e377b2495f81a8f"
  end

  resource "runtime" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/runtime.tgz"
    sha256 "65cd837ebedaaae4dc02135e6903d53db4c24bb0a3f795081f634f1c20f0e34c"
  end

  resource "system" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/system.tgz"
    sha256 "0087f7c5ec45d8f85ea8206bd006eb89777c17a8d9eed6ab9ca937c67a88cf7c"
  end

  resource "bootstrap" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/boot.x86-unix.tgz"
    sha256 "5168f96600e0e97b533582519b51e607345b454733277051c505d86165ef532e"
  end

  resource "mlrisc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/MLRISC.tgz"
    sha256 "835868b96a054d0d5c8cede73905a9a3d94f32a4c0240bd7bf85c3e8989c4fdb"
  end

  resource "lib" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/smlnj-lib.tgz"
    sha256 "5bdc9fe2fa20ea6b108e54725dac3933b5dbc68e43b818b4af2b99f49178a7ee"
  end

  resource "ckit" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/ckit.tgz"
    sha256 "e94cd79aa36e798aa842b4f35ad8dabb6bbcb32fe0abca3770b670af506b050d"
  end

  resource "nlffi" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/nlffi.tgz"
    sha256 "11b4fe2b67b095ee594a4c04b5b8fb88bd4788c939b79857da5955c580243d24"
  end

  resource "cml" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/cml.tgz"
    sha256 "6809094b0597918bed2c86a0fe4a6c95b842fe1891b13f7abbadc337b3b1f917"
  end

  resource "exene" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/eXene.tgz"
    sha256 "46d0fdf328f9bd90a3720f6d3b84dc8c7be5de3c52e046d06baaf9e00c160d85"
  end

  resource "ml-lpt" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/ml-lpt.tgz"
    sha256 "061e0eff80ea0e51aded9e9ab97d7cc1fefd014d8b4f147db2c79bbdc6bce896"
  end

  resource "ml-lex" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/ml-lex.tgz"
    sha256 "3ecdd0e21a2563569526cd7c1d9073506bfebf976c94c7e4821920c3a475a4b4"
  end

  resource "ml-yacc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/ml-yacc.tgz"
    sha256 "fcdc749ec587f271880aeea356189cbf48761eedca5478ea811afce4302ae2a6"
  end

  resource "ml-burg" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/ml-burg.tgz"
    sha256 "91949f33578be7e3e9160401fc86ca8932fc127335be98ab70b1614d42baa747"
  end

  resource "pgraph" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/pgraph.tgz"
    sha256 "d00d67cdae74afb8fb24fa117bca061c68fa193418101444c8fb7afe49bc9a2d"
  end

  resource "trace-debug-profile" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/trace-debug-profile.tgz"
    sha256 "6b7caa5038f1a80107d7b141299749271c63ad2b665bd66d76cf857a69b67159"
  end

  resource "heap2asm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/heap2asm.tgz"
    sha256 "ec04b05228e21b791a203bc80f5763e8d5399bb5c1316d86cc8ecd293a0f5afe"
  end

  resource "c" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.81/smlnj-c.tgz"
    sha256 "31dda7e04a3a3d83b518c5e2e17094e2f386449957bfb2878dd4d5053fe3c395"
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
