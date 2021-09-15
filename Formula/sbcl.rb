class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.8/sbcl-2.1.8-source.tar.bz2"
  sha256 "a3ea7bafcca051073b3769c1ee79d26c3c47cb4eb2f548b07ace38df14e25546"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df642cb657479a6ae84a6adfc22cafbcb876542fb9b69527b4ca2755ffc15e25"
    sha256 cellar: :any_skip_relocation, big_sur:       "66401ff5244705458efadcafd54d949c1ed97371d7d66f74112f1ea514035c7b"
    sha256 cellar: :any_skip_relocation, catalina:      "35994e69427d7a67a06bd82a564342a6e7d39c1cefe98a35de0cd21fb93c72cc"
    sha256 cellar: :any_skip_relocation, mojave:        "84391dfa0666ab321726098f161b9c30aa1a8be2fbc19227c68184c672265f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee12ab34263805a2abb4e1c4923dc666712aa1cac3bffd3a495e84fecbfa779a"
  end

  depends_on "ecl" => :build

  uses_from_macos "zlib"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
