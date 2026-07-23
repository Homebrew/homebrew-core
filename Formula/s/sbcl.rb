class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.6/sbcl-2.6.6-source.tar.bz2"
  sha256 "a65a7a30812aaf54925d1192b9b9e810f527c79911c6000b7548105aef7da34b"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 5
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "551f51af287333c4f3934cd18ef2d47da452d600a25865f31520a7483e5d15fe"
    sha256 cellar: :any, arm64_sequoia: "d422064396d2ed2e6fa42c3c9360285046046ee7199904ceb8d008797968b175"
    sha256 cellar: :any, arm64_sonoma:  "ecb689a56000227dc8a7dbf1b0635ce4299504a07dcee1f3599f17faeaabba20"
    sha256 cellar: :any, sonoma:        "0ebc3331059a82719bbcc07f38ea3582f4c983e31917ef00602938b70a3d8c6f"
    sha256 cellar: :any, arm64_linux:   "f15a968e03ff12935326db442b1002c6d279c0cf1638556198d60c75eb8f9835"
    sha256 cellar: :any, x86_64_linux:  "ce78a4ededea0f49ba8ef68ef4f718d191e774301027f59b20d405c258cb1be7"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  # Revert an arm64 UTF-8 c-string SIMD change that miscompiles string reads and
  # deadlocks multi-process dependents (e.g. fricas); fixed differently after 2.6.6.
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
