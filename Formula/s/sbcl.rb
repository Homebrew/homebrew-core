class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.10/sbcl-2.5.10-source.tar.bz2"
  sha256 "bf5fb49f2a42f36b3e003d2e4d234386addf07d9dd8ca8634656927cc96ce125"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a9de51314cd86b9bb3bf7d8339971d9f5f1387c9264c5c94f4d1ecadb2cc05b"
    sha256 cellar: :any,                 arm64_sequoia: "fb6b4706b4360c37f7cf0df0d34e3fa3cea2fc93a96a555f9e6b03a16fd5f4a4"
    sha256 cellar: :any,                 arm64_sonoma:  "b6d861931d1e49a9621300433929d684a058c142e0dbb869d95b3d99c698a2bd"
    sha256 cellar: :any,                 sonoma:        "8ee5350afc079097b99f6babf0e938473e05dff86b436908d13da58747ed3df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3b08b71887bc25597f013c234b817881b4fc426d3e502d0611f3f4aff7159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d41cd0af071fbdead42078df064c5e33505b3a2bd4cd481bffeb3b4a8edeb64"
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
