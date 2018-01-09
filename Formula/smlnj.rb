class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "https://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.82/config.tgz"
  sha256 "ceff9288e8106d94ce813181d6f4c4da02e4abf808875b27b78d9f6258d016de"

  bottle do
    rebuild 1
    sha256 "453e8cea76fe2330023a8db1cbfbc6429d046ece308dc087e05af4220ce211d2" => :high_sierra
    sha256 "5ebfe510656e7484c41620727a3523841939cfc10585ab5cce3dc7f7b846540b" => :sierra
    sha256 "e2e07693b2f775e68a71382a0d3b8a93e017be550f2348e2ca960a0eddffc943" => :el_capitan
  end

  resource "cm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/cm.tgz"
    sha256 "682fd43ef9021bb3beb62cc95fc60b47b4bf79458f4e3ca20029f1e1d57db207"
  end

  resource "compiler" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/compiler.tgz"
    sha256 "f7fb742608efa1ef4ed34a8791a1014c831708faa83e11d47f9d4242fbd69862"
  end

  resource "runtime" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/runtime.tgz"
    sha256 "39cff4308c4dea8ae59883be651478a49174ff0473edb67ff46420aaa2cddb71"
  end

  resource "system" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/system.tgz"
    sha256 "dee67036542d4cd0cbe18cb323db45de41083fc988f10e26c5c467c69f0d7321"
  end

  resource "bootstrap" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/boot.x86-unix.tgz"
    sha256 "89e66f5a7fe7c811877d3cec4c1e3e4eb909ecca905248c2bf5f7105e2a4f9a5"
  end

  resource "mlrisc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/MLRISC.tgz"
    sha256 "fb5b7e781ae2b7aef2c873bb778c08dad99b816e98d737116b79e7210213fbf2"
  end

  resource "lib" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/smlnj-lib.tgz"
    sha256 "2c008ebea14d193ecea4969dcff7001b107ec724bc05562b7dde1e3dd5d4d1ae"
  end

  resource "ckit" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/ckit.tgz"
    sha256 "3db4e2aa95002698096b2e90c1979fedebb5c3ab0feacc374c0dfecbcb953632"
  end

  resource "nlffi" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/nlffi.tgz"
    sha256 "7789f2c2e2aee03664e69414385f09356a8779c4cf1af74caa8a49f1d913df6b"
  end

  resource "cml" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/cml.tgz"
    sha256 "092399af4825f0c352ed1cfe783bb42a44853fa8798bf8463e4279e41758d2ff"
  end

  resource "exene" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/eXene.tgz"
    sha256 "7a32f77ceefef8c69c38aa9599b777fa073c68dcfb142165f5116f476174381a"
  end

  resource "ml-lpt" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/ml-lpt.tgz"
    sha256 "fd107fcc3c51aa44b59f464bfb92bfff22131b18ddee29f361d01765f51ff286"
  end

  resource "ml-lex" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/ml-lex.tgz"
    sha256 "de7699715b0bbe1e9b67aa5bea5515dfe6aa0e5b2e74abe1f97168a8ad6a0ab5"
  end

  resource "ml-yacc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/ml-yacc.tgz"
    sha256 "1ef667a170fa9c3ec87345f53b7579842c93342b4af8f8c10993551b55f4a366"
  end

  resource "ml-burg" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/ml-burg.tgz"
    sha256 "7f9c300c2553bf95be7f8275bf159bfb1ac7c7e24a9921b375be15c8d6606ae9"
  end

  resource "pgraph" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/pgraph.tgz"
    sha256 "ef40f8386f7fa138b7d5eb93ca3bf86abc072b564f9713f14755cd2b5e404ed9"
  end

  resource "trace-debug-profile" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/trace-debug-profile.tgz"
    sha256 "37a11feacb6ecd9e3d5a727fdd1bd2d0d908f25a03642f42b42bc61839bb29bf"
  end

  resource "heap2asm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/heap2asm.tgz"
    sha256 "1751fe8f0b706181a55f109f2bd1292a406b72d09875df0a9fae727c27742554"
  end

  resource "c" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.82/smlnj-c.tgz"
    sha256 "f879f5354846b84ca3196dbd3ab99615f2a936cfaaa37470f083fa72beeededa"
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
