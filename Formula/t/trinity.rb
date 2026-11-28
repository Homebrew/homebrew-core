class Trinity < Formula
  include Language::Python::Shebang

  desc "RNA-Seq de novo transcriptome assembler"
  homepage "https://github.com/trinityrnaseq/trinityrnaseq/wiki"
  url "https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v2.16.5/trinityrnaseq-v2.16.5.FULL.tar.gz"
  sha256 "a58b2f9a0c74f6a6b904e7eedbb1ab23302156782c7f54a319d67a5a1c234a5c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^Trinity[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "bowtie2"
  depends_on "htslib"
  depends_on "jellyfish"
  depends_on "numpy"
  depends_on "openjdk"
  depends_on "python@3.14"
  depends_on "salmon"
  depends_on "samtools"
  depends_on "trimmomatic"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    # insilico_read_normalization.pl needs DB_File, which Homebrew's perl does not ship
    depends_on "berkeley-db@5"
    depends_on "zlib-ng-compat"

    resource "DB_File" do
      url "https://cpan.metacpan.org/authors/id/P/PM/PMQS/DB_File-1.861.tar.gz"
      sha256 "608bc6ff234ae08ac5bf6b85887882965aaa89554cf09d09fb926fd4e389094f"
    end
  end

  def install
    # Remove prebuilt jars and the bundled Trimmomatic/htslib; all are rebuilt or replaced below
    rm ["Butterfly/Butterfly.jar", "Butterfly/Butterfly/Butterfly.jar", "util/support_scripts/ExitTester.jar"]
    rm_r ["trinity-plugins/Trimmomatic-0.40", "trinity-plugins/bamsifter/htslib-1.22.1.tar.bz2"]

    args = %W[
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      HTSLIB_PREFIX=#{formula_opt_prefix("htslib")}
      TRIMMOMATIC_CODE=#{formula_opt_libexec("trimmomatic")}
    ]
    system "make", "jars", "JAVAC=#{formula_opt_bin("openjdk")}/javac", "JAR=#{formula_opt_bin("openjdk")}/jar"
    system "make", *args
    system "make", "plugins", *args

    # Build trees only: the binaries are already in Inchworm/bin, Chrysalis/bin, trinity-plugins/BIN and slclust/bin
    rm_r %w[Butterfly/Butterfly Docker WDL benchmarking trinityrnaseq.wiki trinity_ext_sample_data
            Inchworm/build Chrysalis/build trinity-plugins/ParaFly trinity-plugins/seqtk-trinity]
    rm Dir["trinity-plugins/slclust/src/*.o"]
    libexec.install Dir["*"]
    if OS.linux?
      resource("DB_File").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/perl5"
        system "make", "install"
      end
    end
    rewrite_shebang detected_python_shebang, *libexec.glob("**/*").select(&:file?)
    env = { PATH: "#{formula_opt_bin("openjdk")}:$PATH" }
    env[:PERL5LIB] = "#{libexec}/perl5/lib/perl5:$PERL5LIB" if OS.linux?
    (bin/"Trinity").write_env_script libexec/"Trinity", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/Trinity --version --no_version_check")

    # Subset of the bundled sample reads keeps the assembly to a few seconds
    %w[left right].each do |side|
      reads = Zlib::GzipReader.open(libexec/"sample_data/test_Trinity_Assembly/reads.#{side}.fq.gz") do |gz|
        gz.each_line.first(20_000)
      end
      (testpath/"#{side}.fq").write reads.join
    end
    system bin/"Trinity", "--seqType", "fq", "--max_memory", "1G", "--CPU", "2", "--no_version_check",
                          "--left", "left.fq", "--right", "right.fq", "--output", "trinity_out",
                          "--trimmomatic"
    assert_match ">TRINITY_DN", (testpath/"trinity_out.Trinity.fasta").read
  end
end
