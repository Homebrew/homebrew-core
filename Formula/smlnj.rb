class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "http://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.80/config.tgz"
  version "110.80"
  sha256 "fd2120ebae607b71778914700385a70b38596e13c350e489c483058693217b03"

  bottle do
    sha256 "b58be5ea2c0a346e8e4852799eb8031396c06d1d17b264e42f7154c4ddcad5a0" => :sierra
    sha256 "fc353e6d773f98a37abc5dac918ff3403d713f20ef1c920685399bf81041a5a4" => :el_capitan
    sha256 "7d48eadff3701885a4bf181efae449caa3b81fe0fcbbc909db8669eca8f9b6dd" => :yosemite
    sha256 "e88f8bc8a40eb4b2149c9d3266de6936b08b29eed978af827d6326d6cac1f7b9" => :mavericks
  end

  resource "cm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/cm.tgz"
    sha256 "ae892f431c6c570e52603c3297b829a81cd0e126c3793a484eaf37966c52820c"
  end

  resource "compiler" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/compiler.tgz"
    sha256 "f1855a1070793cd4474af2752a816d72227994233a000877c27b2c4269a60d6e"
  end

  resource "runtime" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/runtime.tgz"
    sha256 "6e13a544bd346e6b4103d51300290eb2f056983c903aa658db3b1489a8ab9d45"
  end

  resource "system" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/system.tgz"
    sha256 "dc2198c9c423af9c5f3d65da7166ba690e1672291a247cd1e6ba9e8419eaf1a8"
  end

  resource "bootstrap" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/boot.x86-unix.tgz"
    sha256 "e4e0def3d38816eab5ce3d50b0c6d732779ff83ef65d2aef34b7c69d780a3488"
  end

  resource "mlrisc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/MLRISC.tgz"
    sha256 "425a4b648e0f5d0cf660e5a325756cf6f373daacf8261d8c424d163d277fd9f0"
  end

  resource "lib" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/smlnj-lib.tgz"
    sha256 "a8c3aca6a638fff540055791236f5bc30e7d8044782d220beddd711eaa7ea352"
  end

  resource "ckit" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/ckit.tgz"
    sha256 "7fe672bbdb917aca5825246658b692b63f7f66a15afefeb707baf914263187ba"
  end

  resource "nlffi" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/nlffi.tgz"
    sha256 "4d1b048b4bced62820dba17b92e0276d34336f98f298aa77240da6d8fed5a128"
  end

  resource "cml" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/cml.tgz"
    sha256 "23ae9fcf214636301941119b46b044f61f1d2f4b6f337b2fe72213e18a7a489a"
  end

  resource "exene" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/eXene.tgz"
    sha256 "c94ec84f8c0495739fd70d06d867d84902b83081ebf80b5dfd3e165cad85a759"
  end

  resource "ml-lpt" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/ml-lpt.tgz"
    sha256 "3d73a4c0d68694adeec6111f10a94386204db51fc86814669c364802776b0c79"
  end

  resource "ml-lex" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/ml-lex.tgz"
    sha256 "441c2895b0cf592a207a5bc13ec5625f3463b32c7b7f7cd717f16ce587073102"
  end

  resource "ml-yacc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/ml-yacc.tgz"
    sha256 "64c7acaa07e664f7751e46da1d6c9c1d3a080f70b28fcf611e05fd96e1382ca1"
  end

  resource "ml-burg" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/ml-burg.tgz"
    sha256 "fcade4c8518621099022bc28d4795e6ae972f8b3b64b01fb14778a714bfe44db"
  end

  resource "pgraph" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/pgraph.tgz"
    sha256 "d899170691322c7de1f9662f89d6be6e955c33b42d751074a1ac5a8a560795bc"
  end

  resource "trace-debug-profile" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/trace-debug-profile.tgz"
    sha256 "d1148cddbff76e38a96d2db95edb33b5b81e603ce8e2d4e8d3b4b54040db934a"
  end

  resource "heap2asm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/heap2asm.tgz"
    sha256 "bc9a78cabdffec2dca7e52e73f35272b1a93b4a012197372a945b75a3857219a"
  end

  resource "c" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.80/smlnj-c.tgz"
    sha256 "7fe9eba124052ea72ea724a011f8f88297b3debd292d452aba1d1934dddcd20d"
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
    <<-EOS.undent
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
    assert File.exist?("NLFFI-Generated/nlffi-generated.cm")
  end
end
