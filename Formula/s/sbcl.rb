class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.8/sbcl-2.6.8-source.tar.bz2"
  sha256 "ad5126dfdfba5db27ee77bcc25893020fe522d0b7653d45b4c4795ade3ddc23d"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 7
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b3b730cc0bd242bfe5010d510d843ec19d8db56a7b6fb722caa4607c1435ab9e"
    sha256 cellar: :any, arm64_tahoe:       "0054638247d463759dd1dfc8694cf519c7ceb690f6cc5471f8d09bc54ef59a5c"
    sha256 cellar: :any, arm64_sequoia:     "4f79a06ecba982c60ace2bf96d54630beab47782c661741d809fb2789a61d671"
    sha256 cellar: :any, arm64_sonoma:      "4c84064407869d59632862316bc4a510235473e0151821c69938c166ad9b7c99"
    sha256 cellar: :any, arm64_linux:       "6412eeed9d5da9a114d32a5b6bbde3f43651055ca954fe0c794551f2d12c1952"
    sha256 cellar: :any, x86_64_linux:      "582df812e4fe1d8950bca523c041db3003d4aa85c1fb057e4558da48f01cf5de"
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
