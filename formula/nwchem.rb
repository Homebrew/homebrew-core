# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Nwchem < Formula
  desc "NWChem: Open Source High-Performance Computational Chemistry"
  homepage "http://www.nwchem-sw.org"
  url "https://github.com/nwchemgit/nwchem/releases/download/6.8.1-release/nwchem-6.8.1-release.revision-v6.8-133-ge032219-srconly.2018-06-14.tar.bz2"
  sha256 "fd20f9ca1b410270a815e77e052ec23552f828526cd252709f798f589b2a6431"
  depends_on "openblas"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "scalapack"

  def install
    cd "src" do
      system "make", "nwchem_config", "NWCHEM_MODULES=nwdft python", "NWCHEM_TOP=#{Dir.pwd}/.."
      system "make", "64_to_32", "NWCHEM_TOP=#{Dir.pwd}/.."
      system "make", "NWCHEM_TARGET=MACX64", "USE_MPI=Y", "NWCHEM_TOP=#{Dir.pwd}/..", "BLASOPT=-L#{Formula["openblas"].opt_lib} -lopenblas", "BLAS_SIZE=4", "SCALAPACK=-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack", "USE_64TO32=y", "PYTHONVERSION=2.7", "PYTHONHOME=/usr", "NWCHEM_LONG_PATHS=Y"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test nwchem`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
