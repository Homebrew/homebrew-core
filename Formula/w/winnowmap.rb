class Winnowmap < Formula
  desc "Long-read/genome alignment using weighted minimizers"
  homepage "https://github.com/marbl/Winnowmap"
  url "https://github.com/marbl/Winnowmap/archive/refs/tags/v2.03.tar.gz"
  sha256 "f6375960ee2184b68c0f56d3ca95e12ec3218f9e44aeecbdb14f85f581112c83"
  license all_of: [:public_domain, "MIT"]
  head "https://github.com/marbl/Winnowmap.git", branch: "master"

  # meryl (bundled Canu k-mer counter) refuses to compile with Clang, and both
  # tools use OpenMP, so build the whole project with GCC.
  depends_on "gcc"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    gcc = Formula["gcc"]
    gcc_major = gcc.version.major
    args = %W[
      CC=#{gcc.opt_bin}/gcc-#{gcc_major}
      CXX=#{gcc.opt_bin}/g++-#{gcc_major}
    ]
    # Use the bundled sse2neon shim on ARM, mirroring minimap2's own build.
    args += ["arm_neon=1", "aarch64=1"] if Hardware::CPU.arm?

    # Bundled meryl includes <sys/sysctl.h>, which glibc removed in 2.32. That
    # header is also what defines HW_PHYSMEM, the only guard around meryl's
    # sysctl() calls, so skipping it on Linux selects the sysconf() code path
    # meryl already provides. Fixed upstream after v2.03 but never released:
    # https://github.com/marbl/Winnowmap/issues/28
    inreplace "ext/meryl/src/utility/src/utility/system.C",
              "#if !defined(__CYGWIN__) && !defined(_WIN32)",
              "#if !defined(__CYGWIN__) && !defined(_WIN32) && !defined(__linux__)"

    # The top-level Makefile exports CPPFLAGS and runs the src sub-make with -e,
    # so the environment wins and src/Makefile's own aarch64 `-fsigned-char` is
    # dropped. Only bites where char is unsigned by default, i.e. ARM Linux;
    # macOS and x86 keep char signed, which is why upstream never hit it.
    # Reported upstream: https://github.com/marbl/Winnowmap/issues/59
    inreplace "Makefile", "+$(MAKE) -e -C src", "+$(MAKE) -C src"

    system "make", *args
    bin.install "bin/winnowmap", "bin/meryl"
  end

  test do
    # Build a small reference and take an exact substring as a read; it must map
    # back to the originating position with a full-length match.
    ref = "ACGTACGTAGCTAGCTAGCTAGCTACGATCGATCGATCGATCGATCGTAGCTAGCTAGCATCGA" \
          "TCGATCGTAGCTAGCTAGCACGTACGTACGTTTGGCCAATTGGCCAATTAGGCCTTAAGGCCTT" \
          "AACCGGTTAACCGGTTGGATCCGGATCCAAGCTTAAGCTTGAATTCGAATTCCTGCAGGCTGCAG"
    (testpath/"ref.fa").write ">ref\n#{ref}\n"
    read = ref[40, 120]
    (testpath/"reads.fq").write "@r1\n#{read}\n+\n#{"I" * read.length}\n"

    # meryl counts k-mers used by Winnowmap for weighting
    system bin/"meryl", "count", "k=15", "output", testpath/"db.meryl", testpath/"ref.fa"
    assert_predicate testpath/"db.meryl", :directory?

    output = shell_output("#{bin}/winnowmap -ax map-ont #{testpath}/ref.fa #{testpath}/reads.fq 2>/dev/null")
    record = output.lines.grep_v(/^@/).first.split("\t")
    assert_equal "r1", record[0]
    assert_equal "ref", record[2]     # mapped to the reference
    assert_equal "41", record[3]      # 1-based position of the substring
  end
end
