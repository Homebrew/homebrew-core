class Scotch < Formula
  desc "Graph and mesh partitioning, clustering, and sparse matrix ordering"
  homepage "https://gforge.inria.fr/projects/scotch"
  url "https://gforge.inria.fr/frs/download.php/file/34618/scotch_6.0.4.tar.gz"
  sha256 "f53f4d71a8345ba15e2dd4e102a35fd83915abf50ea73e1bf6efe1bc2b4220c7"

  depends_on "open-mpi"
  depends_on "xz"

  def install
    ENV.deparallelize if MacOS.version >= :sierra
    cd "src" do
      ln_s "Make.inc/Makefile.inc.i686_mac_darwin10", "Makefile.inc"
      # default CFLAGS:
      # -O3 -Drestrict=__restrict -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD
      # -DCOMMON_PTHREAD_BARRIER -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_TIMING_OLD
      # -DSCOTCH_PTHREAD -DSCOTCH_RENAME
      # MPI implementation is not threadsafe, do not use DSCOTCH_PTHREAD

      cflags   = %w[-O3 -fPIC -Drestrict=__restrict -DCOMMON_PTHREAD_BARRIER
                    -DCOMMON_PTHREAD
                    -DSCOTCH_CHECK_AUTO -DCOMMON_RANDOM_FIXED_SEED
                    -DCOMMON_TIMING_OLD -DSCOTCH_RENAME
                    -DCOMMON_FILE_COMPRESS_BZ2 -DCOMMON_FILE_COMPRESS_GZ]
      ldflags  = %w[-lm -lz -lpthread -lbz2]

      cflags  += %w[-DCOMMON_FILE_COMPRESS_LZMA]   if build.with? "xz"
      ldflags += %W[-L#{Formula["xz"].lib} -llzma] if build.with? "xz"

      make_args = ["CCS=#{ENV["CC"]}",
                   "CCP=mpicc",
                   "CCD=mpicc",
                   "RANLIB=echo",
                   "CFLAGS=#{cflags.join(" ")}",
                   "LDFLAGS=#{ldflags.join(" ")}"]

      make_args << "LIB=.dylib"
      make_args << "AR=libtool"
      arflags = ldflags.join(" ") + " -dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o"
      make_args << "ARFLAGS=#{arflags}"

      system "make", "scotch", "VERBOSE=ON", *make_args
      system "make", "ptscotch", "VERBOSE=ON", *make_args
      system "make", "install", "prefix=#{prefix}", *make_args
    end

    # Install documentation + sample graphs and grids.
    doc.install Dir["doc/*.pdf"]
    pkgshare.install Dir["doc/*.f"], Dir["doc/*.txt"]
    pkgshare.install "grf", "tgt"
  end

  test do
    mktemp do
      system "echo cmplt 7 | #{bin}/gmap #{pkgshare}/grf/bump.grf.gz - bump.map"
      system "#{bin}/gmk_m2 32 32 | #{bin}/gmap - #{pkgshare}/tgt/h8.tgt brol.map"
      system "#{bin}/gout", "-Mn", "-Oi", "#{pkgshare}/grf/4elt.grf.gz", "#{pkgshare}/grf/4elt.xyz.gz", "-", "graph.iv"
    end
  end
end
