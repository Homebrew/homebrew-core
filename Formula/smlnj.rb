class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "https://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.85/config.tgz"
  sha256 "a1bec62058678157f4142228fd6c074d9c3f3c8eca4bf13d0feec40df0c891e2"

  bottle do
    sha256 "d4441907f2dea02188487b3247e402d70b867a6bdd0e84da0cf5e8d7a0d44540" => :sierra
  end

  # Mojave doesn't support 32-bit builds, and thus smlnj fails to compile.
  # This will only be safe to remove when upstream support 64-bit builds.
  depends_on :maximum_macos => [:high_sierra, :build]

  resource "cm" do
    url "https://www.smlnj.org/dist/working/110.85/cm.tgz"
    sha256 "05043d490e613ed85d2542cf0c8ad1f50922ea8c58aaa76141c0bfaeea94600c"
  end

  resource "compiler" do
    url "https://www.smlnj.org/dist/working/110.85/compiler.tgz"
    sha256 "358974715cdce99dd12fff7f732dfde31940750a3f0098291b4f8c91e2c638ff"
  end

  resource "runtime" do
    url "https://www.smlnj.org/dist/working/110.85/runtime.tgz"
    sha256 "c435f73728bbba585719a746f46384075a16e84bc5920ea3270345a1536a30d9"
  end

  resource "system" do
    url "https://www.smlnj.org/dist/working/110.85/system.tgz"
    sha256 "a8ba7b15d07c9ddc922da3677546d2535c75f50263c471661d9f7d4a54ac4a9f"
  end

  resource "bootstrap" do
    url "https://www.smlnj.org/dist/working/110.85/boot.x86-unix.tgz"
    sha256 "8a9269818dc6f9d9587c8447e13fd07a71fe169ff6ac6a92fee66e498e0f3017"
  end

  resource "mlrisc" do
    url "https://www.smlnj.org/dist/working/110.85/MLRISC.tgz"
    sha256 "28e86de090e3bf150a7aba322a913e10948091e53b851ff89ecb24df79332f0d"
  end

  resource "lib" do
    url "https://www.smlnj.org/dist/working/110.85/smlnj-lib.tgz"
    sha256 "cd48d7fd190bfafc2d209e4466368f955725dbca5de8c81fc6a6de786de064f2"
  end

  resource "ckit" do
    url "https://www.smlnj.org/dist/working/110.85/ckit.tgz"
    sha256 "d185a6bc577bc0ea5cc7f5248e1b08ba9c2b376c4fd05f76748d60b8057f1d93"
  end

  resource "nlffi" do
    url "https://www.smlnj.org/dist/working/110.85/nlffi.tgz"
    sha256 "fcf8ab0f2438768530a3b4bfaaa40f86af7d23f35dd3bb1a6e64403fbf8e889a"
  end

  resource "cml" do
    url "https://www.smlnj.org/dist/working/110.85/cml.tgz"
    sha256 "43d1d06a8e62bcf21efb48f0d9c67c469eeeb40ba953f9f0cd43e191c9c7b415"
  end

  resource "exene" do
    url "https://www.smlnj.org/dist/working/110.85/eXene.tgz"
    sha256 "c2323b9a380d4e8cd621d5721e4691df69a4096688bdd4959bd0086dfb87aa1e"
  end

  resource "ml-lpt" do
    url "https://www.smlnj.org/dist/working/110.85/ml-lpt.tgz"
    sha256 "602e6c553d4ea82bdea2d7a6cf70d23b91e54a41896308b5cfc15094ac83e300"
  end

  resource "ml-lex" do
    url "https://www.smlnj.org/dist/working/110.85/ml-lex.tgz"
    sha256 "984edf37721f94851505a5902128521e46729fc08e09d3e787db73e24ea8d380"
  end

  resource "ml-yacc" do
    url "https://www.smlnj.org/dist/working/110.85/ml-yacc.tgz"
    sha256 "09e7ac57f9defd6902bae1d539cbd04bfba69e227a4d7fc31139da8e3e3d13e4"
  end

  resource "ml-burg" do
    url "https://www.smlnj.org/dist/working/110.85/ml-burg.tgz"
    sha256 "096aefd291ceff19722d3236984522147de5edfa4a91837d06e5f645af565882"
  end

  resource "pgraph" do
    url "https://www.smlnj.org/dist/working/110.85/pgraph.tgz"
    sha256 "c0a89e954c8974c3d07aa71ce39d549cf02add461bfd97d09dc99f95576bb8df"
  end

  resource "trace-debug-profile" do
    url "https://www.smlnj.org/dist/working/110.85/trace-debug-profile.tgz"
    sha256 "e78daf92821e33992ad9ca91ca63ba2269c41b996c0ceb547da1e6f6dba56a3a"
  end

  resource "heap2asm" do
    url "https://www.smlnj.org/dist/working/110.85/heap2asm.tgz"
    sha256 "ecc6057d18193960a55dc14e3906108655d4bf39fdb29101062e7bea739dcf14"
  end

  resource "c" do
    url "https://www.smlnj.org/dist/working/110.85/smlnj-c.tgz"
    sha256 "7cfa26a11f80b7418a67a4194c639eedbcb429b6fc732f3569b61549bd958411"
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
