class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.7/sbcl-2.6.7-source.tar.bz2"
  sha256 "1ebdc35c9dc8e271b8cd1ac44965e00bf255f9c0221650fcb77f0fb34c2d3ade"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 6
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "39d14fd0375b38c571b533536f08656a396ba41750469984ed6843bfb510a421"
    sha256 cellar: :any, arm64_sequoia: "4ff675badc761a7e0fcf63428effa551abe1e954f28f79d857c77292a2b6d4a7"
    sha256 cellar: :any, arm64_sonoma:  "121f869e45c6a5b25cde2eecba2c42c0767b6f587d81d77aa0c160f79f4e1f8b"
    sha256 cellar: :any, sonoma:        "6154781f8af03a1668f95c102f4023cc6ce47b04a39d7b827e85fd563775306b"
    sha256 cellar: :any, arm64_linux:   "f4f78a00d7166a66d839a88816d0f065c4168fc72cfdb96ed0e7eb5e54127d34"
    sha256 cellar: :any, x86_64_linux:  "cc777d06dbab4cd0f07daf83740049fed9e433c29c81be6b0cb02f92bd1f6ce7"
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
