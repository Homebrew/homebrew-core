class Nwchem < Formula
  desc "NWChem: Open Source High-Performance Computational Chemistry"
  homepage "http://www.nwchem-sw.org"
  url "https://github.com/nwchemgit/nwchem/releases/download/6.8.1-release/nwchem-6.8.1-release.revision-v6.8-133-ge032219-src.2018-06-14.tar.bz2"
  version "6.8.1"
  sha256 "23ce8241a5977a93d8224f66433851c81a08ad58a4c551858ae031485b095ab7"
  depends_on "openblas"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "scalapack"

  def install
    cd "QA" do
      (prefix/"QA").mkdir
      (prefix/"QA/tests").mkdir
      cp "runtests.mpi.unix", prefix/"QA"
      cp "nwparse.pl", prefix/"QA"
      cp_r "tests/dft_he2+", prefix/"QA/tests"
      cp_r "tests/prop_mep_gcube", prefix/"QA/tests"
      cp_r "tests/tce_n2", prefix/"QA/tests"
      cp_r "tests/tddft_h2o", prefix/"QA/tests"
      cp_r "tests/pspw", prefix/"QA/tests"
    end
    cd "src" do
      (prefix/"etc").mkdir
      (prefix/"etc/nwchemrc").write <<~EOS
        nwchem_basis_library #{share}/libraries/
        nwchem_nwpw_library #{share}/libraryps/
        ffield amber
        amber_1 #{share}/amber_s/
        amber_2 #{share}/amber_q/
        amber_3 #{share}/amber_x/
        amber_4 #{share}/amber_u/
        spce    #{share}/solvents/spce.rst
        charmm_s #{share}/charmm_s/
        charmm_x #{share}/charmm_x/
      EOS
      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", "#{etc}/nwchemrc"
      inreplace "config/makefile.h" do |s|
        s.gsub! /-mtune=native/, "-mtune=generic"
        s.gsub! /-mfpmath=sse/, " "
        s.gsub! /-msse3/, " "
      end
      ENV["NWCHEM_TOP"] = "#{Dir.pwd}/.."
      ENV["PYTHONVERSION"] = "2.7"
      ENV["PYTHONHOME"] = "/usr"
      ENV["NWCHEM_LONG_PATHS"] = "Y"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["USE_64TO32"] = "y"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python"
      system "make", "64_to_32"
      system "make", "NWCHEM_TARGET=MACX64", "USE_MPI=Y"
      bin.install "../bin/MACX64/nwchem"
      (prefix/"share").mkdir
      share.install "basis/libraries"
      share.install "nwpw/libraryps"
      share.install Dir["data/*"]
      rm Dir["#{share}/libraryps/*F"]
      rm Dir["#{share}/libraryps/*fh"]
      rm Dir["#{share}/libraryps/*ake*ile"]
      rm Dir["#{share}/libraryps/dep*ies"]
      rm Dir["#{share}/libraryps/incl*mp"]
    end
  end

  test do
    cp_r prefix/"QA", testpath
    cd "QA" do
      ENV["NWCHEM_TOP"] = "/usr/local/Cellar/nwchem/6.8.1"
      ENV["NWCHEM_TARGET"] = "MACX64"
      ENV["NWCHEM_EXECUTABLE"] = "/usr/local/bin/nwchem"
      system "./runtests.mpi.unix", "procs", "2", "dft_he2+", "prop_mep_gcube"
      system "./runtests.mpi.unix", "procs", "2", "pspw"
      system "./runtests.mpi.unix", "procs", "2", "tddft_h2o"
      system "./runtests.mpi.unix", "procs", "2", "tce_n2"
    end
  end
end
