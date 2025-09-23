class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.8/sbcl-2.5.8-source.tar.bz2"
  sha256 "a7603e855095f635de021710a4e720d74d0b3e7c3e7ac520fe358897f586a9ae"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "436521335b01216cdaedff210b3c7fbd5b7679038bc8c9edcaf5950b654d24ad"
    sha256 cellar: :any,                 arm64_sequoia: "e03ccb0747a6ad142810c70364bdecb15011d34721494d412d697c57202ae625"
    sha256 cellar: :any,                 arm64_sonoma:  "5a88a94e002b1f2984648a2a31d8c41882c1de6cc2a7bf7265a7678417620402"
    sha256 cellar: :any,                 arm64_ventura: "61a3b52295a7f9d8f8fbf4db8b092e6306079b03ee6057b5daa2ef62e111279b"
    sha256 cellar: :any,                 sonoma:        "3fa96de63a1396d25a7a9fc0c8a6ef4d8ea8086a821056b63f0577c7439a95e6"
    sha256 cellar: :any,                 ventura:       "599ba733c84bd77370d29e77078a88fdddbae9e0fe895b18fafcf3a2e45cf99d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0fff13e9a08d14ba6b46a1a4a08710d562903d1691054d35b0be7645bfb21a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97014ab68c7a0d16a87b1d708cfba14e46fc6e61a13a2ad37512ec24c8d5b922"
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
