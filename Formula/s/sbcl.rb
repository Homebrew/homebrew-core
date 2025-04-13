class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.3/sbcl-2.5.3-source.tar.bz2"
  sha256 "8a1e76e75bb73eaec2df1ee0541aab646caa1042c71e256aaa67f7aff3ab16d5"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a43d574ca421eed9c9b8e18e7039d96a80db27c4a4608b486fbcf6d42c0a1eee"
    sha256 cellar: :any,                 arm64_sonoma:  "93257326dfa10f13cadd5070748cf277a2913c880b878a1e6ef3bf01c02daa28"
    sha256 cellar: :any,                 arm64_ventura: "5e103518ab8f5e339a8eb26d9d4f22fb614163909c81f0bebbf0dbeb309a6a0b"
    sha256 cellar: :any,                 sonoma:        "979b302a10c36c65de4107f173105376101af93ae0fb819af012435ba70dab11"
    sha256 cellar: :any,                 ventura:       "a4fff20aeed3eb87f14a216561449f3e6f347fbd0e31ba0ded2a1e1103ba3088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d0b398c7f78f032fc0c3c4e0f940b43a97bc8077ec9b3119e95191222687ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8366de0d738d6c862d604030e749f5b689e0f5857956c3d152c262d368e3d5b6"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

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
