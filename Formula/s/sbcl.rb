class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.10/sbcl-2.6.10-source.tar.bz2"
  sha256 "c23eac1d0aa9ae0add7eb741f3c91b816f5ce216147f37b99da1578e5261b17c"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 9
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "51472a993f01f7657ea20d0b73c86f333a544e77a7d905855f50035a3a27fcf3"
    sha256 cellar: :any, arm64_tahoe:       "76b49e3ec6f6513ac15e4f94686d00bfa3e79d17ee437e8bdd0682071083a974"
    sha256 cellar: :any, arm64_sequoia:     "ba4949e62ab71def6ef27f843cddcb376172a1bf012f646d3ab3e50f8deec57a"
    sha256 cellar: :any, arm64_linux:       "9316d0beb7e1e0e05804d8ed5b26c490f8263adc2b94e928eba30498622f521a"
    sha256 cellar: :any, x86_64_linux:      "29c906b341d4175c011ead65372c26dfb82d056dbcd61a7a849617c049297870"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  # Stop passing raw SAPs through the arm64 fixed-args convention, which miscompiles
  # UTF-8 c-string reads and hangs multi-process dependents (e.g. acl2, fricas).
  patch do
    file "Patches/sbcl/revert-utf8-c-string-simd-regression.patch"
    type :unofficial
  end

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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
